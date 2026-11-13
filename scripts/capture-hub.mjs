#!/usr/bin/env node
// Screenshot of the example bulletin open in the Quarto Hub editor, served locally by q2
// (`q2 preview --ui editor`), for a possible backup slide on Quarto 2 (not in the deck).
//
// q2 is experimental: the bulletin is written for Quarto 1, so the script renders a patched
// copy in _check/hub/ (example/ is never touched). Each patch works around a q2 gap:
//   - `brand: _brand.yml` added: q2 does not find _brand.yml on its own (Q-14-1 with theme: brand);
//   - `date-modified: last-modified` dropped: the live preview cannot resolve it (render can);
//   - a comment `[>> ...]` added after the key figure sentence: what the slide shows.
// Inline R must use the brace spelling `{r} expr`: the live preview does not evaluate knitr's
// `r expr` (the key figure would then show no number and the script stops).
//
// Needs q2 on the PATH (https://github.com/quarto-dev/q2, or Q2=/path/to/q2) and the example's
// R packages (just example-deps). Usage: node scripts/capture-hub.mjs [--comment "text"]
//   (or: just hub). Output: _check/hub-editor.png (gitignored). Quarto Hub is not open to the
//   public yet: keep this image out of images/, which is published with the deck.
import { createRequire } from 'node:module';
import { spawn } from 'node:child_process';
import fs from 'node:fs';
import path from 'node:path';

const args = process.argv.slice(2);
const opt = (name, def) => { const i = args.indexOf(name); return i >= 0 ? args[i + 1] : def; };
const comment = opt('--comment', 'Same sentence in the press release? -Communication unit');
const port = Number(opt('--port', 4321));
const q2 = process.env.Q2 || 'q2';

function loadPlaywright() {
  // Same lookup as check-slides.mjs: NODE_PATH (Claude cloud) or the repository's node_modules
  for (const base of [import.meta.url, path.join(process.cwd(), 'noop.js')]) {
    for (const name of ['playwright', 'playwright-core']) {
      try { return createRequire(base)(name); } catch { /* try next */ }
    }
  }
  throw new Error('Playwright not found. Run `just setup`.');
}

// 1. Patched copy of the example
const src = path.resolve('example');
const dir = path.resolve('_check', 'hub');
fs.rmSync(dir, { recursive: true, force: true });
fs.mkdirSync(dir, { recursive: true });
for (const f of ['bulletin.qmd', '_quarto.yml', '_brand.yml', 'brand']) {
  fs.cpSync(path.join(src, f), path.join(dir, f), { recursive: true });
}
// R finds the project library through these (rig rvenv); link rather than copy
for (const f of ['.Renviron', '.rvenvlib', '.rvenv']) {
  if (fs.existsSync(path.join(src, f))) {
    const isDir = fs.statSync(path.join(src, f)).isDirectory();
    fs.symlinkSync(path.join(src, f), path.join(dir, f), isDir ? 'junction' : 'file');
  }
}
const qy = path.join(dir, '_quarto.yml');
fs.writeFileSync(qy, 'brand: _brand.yml\n' + fs.readFileSync(qy, 'utf8'));
let qmd = fs.readFileSync(path.join(dir, 'bulletin.qmd'), 'utf8');
qmd = qmd.replace(/^date-modified:.*\n/m, '');
const anchor = 'compared with a year earlier.';
if (!qmd.includes(anchor)) throw new Error(`Key figure sentence not found ("${anchor}")`);
qmd = qmd.replace(anchor, `${anchor}[>> ${comment}]`);
fs.writeFileSync(path.join(dir, 'bulletin.qmd'), qmd);

// 2. q2 editor
const child = spawn(q2, ['preview', '--ui', 'editor', '--no-browser', '--allow-edit',
  '--port', String(port), 'bulletin.qmd'], { cwd: dir, stdio: ['ignore', 'pipe', 'pipe'] });
let log = '';
child.stdout.on('data', d => { log += d; });
child.stderr.on('data', d => { log += d; });
child.on('error', e => { console.error(`Cannot start ${q2}: ${e.message}`); process.exit(2); });
const stop = () => { try { child.kill(); } catch { /* already gone */ } };
process.on('exit', stop);

const deadline = Date.now() + 60000;
let url;
while (!(url = log.match(new RegExp(`http://127\\.0\\.0\\.1:${port}/\\S+`))?.[0])) {
  if (Date.now() > deadline || child.exitCode !== null) {
    console.error('q2 preview did not start:\n' + log);
    process.exit(2);
  }
  await new Promise(r => setTimeout(r, 500));
}
console.log(`q2 editor at ${url}`);

// 3. Screenshot once the R code has run and the key figure shows a number
const { chromium } = loadPlaywright();
const browser = await chromium.launch();
const page = await browser.newPage({ viewport: { width: 1600, height: 900 }, deviceScaleFactor: 2 });
await page.goto(url);
const preview = () => page.frames().find(f => f.url().includes('q2-preview'));
let ok = false;
for (let t = 0; t < 120 && !ok; t++) {
  await page.waitForTimeout(2000);
  const text = await preview()?.evaluate(() => document.querySelector('#kf-nights')?.textContent ?? '').catch(() => '');
  ok = /\d+\.\d million/.test(text || '');
}
if (!ok) {
  console.error('The key figure never showed a number (R code not run?). q2 log:\n' + log.slice(-3000));
  await browser.close();
  process.exit(1);
}
await page.getByRole('button', { name: 'Toggle sidebar' }).click();
// Source: scroll to the key figure lines; preview: the key figure at the top
const editor = page.locator('.monaco-editor').first();
await editor.click({ position: { x: 300, y: 200 } });
await page.keyboard.press('Control+G');
const lineNo = qmd.split('\n').findIndex(l => l.startsWith('::: {#kf-nights}')) + 1;
await page.keyboard.type(String(lineNo));
await page.keyboard.press('Enter');
await page.keyboard.press('Control+G'); // reveal the line near the top: go to it twice from below
await page.keyboard.type(String(lineNo));
await page.keyboard.press('Enter');
await page.waitForTimeout(1000);
// Preview: put the key figure at the height of its source line, so both read side by side
const lineTop = await page.locator('.monaco-editor .current-line').first().boundingBox();
const frameTop = await page.locator('iframe').first().boundingBox();
await preview().evaluate(y => {
  const kf = document.querySelector('#kf-nights');
  window.scrollTo(0, kf.getBoundingClientRect().top + window.scrollY - y);
}, Math.max(0, (lineTop?.y ?? 300) - (frameTop?.y ?? 0) - 10));
await page.waitForTimeout(1000);
// The comment bubble shows its first words only; a click opens it in full
await preview().locator('.q2-comment-bubble').first().click();
await page.waitForTimeout(1500);

const shot = path.join('_check', 'hub-editor.png');
await page.screenshot({ path: shot });
console.log(`ok   ${shot}  (${await page.evaluate(() => navigator.userAgent.match(/Chrome\/[\d.]+/)?.[0])})`);
await browser.close();
stop();
process.exit(0);
