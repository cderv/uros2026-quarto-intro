#!/usr/bin/env node
// Check a Quarto revealjs deck before the talk, and export it to PDF.
//
//   node scripts/check-slides.mjs [index.qmd] [options]
//
// Three levels of checks:
//   1. render:  `quarto render` must succeed; with --strict, its WARNINGs are errors.
//   2. browser: every slide is visited in Chromium (Playwright); console errors,
//               JavaScript errors, failed requests and broken images are reported.
//   3. layout:  content that goes beyond the slide box (e.g. 1280x720) is reported,
//               and one screenshot per slide is saved.
// The PDF export (--pdf, --pdf-only) reuses the same walk: background iframes are
// captured during the walk, then the deck is printed with revealjs `?print-pdf`.
//
// Requirements: Quarto, Node.js >= 18, and Playwright with Chromium
// (`npm install --no-save playwright` then `npx playwright install chromium`).
// Run `node scripts/check-slides.mjs --help` for the options.

import { createRequire } from 'node:module';
import { spawnSync } from 'node:child_process';
import http from 'node:http';
import fs from 'node:fs';
import path from 'node:path';

const USAGE = `Usage: node scripts/check-slides.mjs [input] [options]

Check a Quarto revealjs deck (render, browser, layout) and optionally export it to PDF.

Arguments:
  input                 .qmd to render (default: index.qmd) or an already rendered .html

Options:
  --strict              treat WARNINGs of quarto render as errors (use in CI)
  --no-render           do not render; check the existing .html next to the .qmd
  --pdf [file]          after the checks, export the deck to PDF (default: slides-full.pdf)
  --pdf-only [file]     export to PDF without running the checks
  --pdf-fragments       one PDF page per fragment step (default: final state of each slide)
  --out <dir>           directory for screenshots and reports (default: _check)
  -h, --help            show this help

Outputs (in --out):
  slides/NN-<id>.png    one screenshot per slide, all fragments shown
  report.json           every issue, per slide
  report.md             readable summary (also appended to $GITHUB_STEP_SUMMARY in CI)

Layout checks skip .r-fit-text, .absolute and .scrollable content; add the class
.no-overflow-check to a slide or an element to skip it on purpose.

Exit codes: 0 no error, 1 the deck has errors, 2 tool or environment problem.`;

// ---------------------------------------------------------------- arguments

class UsageError extends Error {}

function parseArgs(argv) {
  const opts = {
    input: null, strict: false, render: true, pdf: null, checks: true,
    pdfFragments: false, out: '_check', help: false,
  };
  const optionalPdfValue = (i) =>
    argv[i + 1] && !argv[i + 1].startsWith('-') && argv[i + 1].toLowerCase().endsWith('.pdf');
  for (let i = 0; i < argv.length; i++) {
    const a = argv[i];
    switch (a) {
      case '-h': case '--help': opts.help = true; break;
      case '--strict': opts.strict = true; break;
      case '--no-render': opts.render = false; break;
      case '--pdf-fragments': opts.pdfFragments = true; break;
      case '--pdf':
      case '--pdf-only':
        opts.pdf = optionalPdfValue(i) ? argv[++i] : 'slides-full.pdf';
        if (a === '--pdf-only') opts.checks = false;
        break;
      case '--out':
        if (!argv[i + 1] || argv[i + 1].startsWith('-')) throw new UsageError('--out needs a directory');
        opts.out = argv[++i];
        break;
      default:
        if (a.startsWith('-')) throw new UsageError(`unknown option ${a}`);
        if (opts.input) throw new UsageError(`only one input file, got ${opts.input} and ${a}`);
        opts.input = a;
    }
  }
  opts.input ??= 'index.qmd';
  return opts;
}

// ---------------------------------------------------------------- reporting

const issues = []; // { level: 'error'|'warning', kind, slide: index|null, message }
function report(level, kind, slide, message) {
  // revealjs preloads the next slides: an error first seen at page load or on a previous
  // slide shows up again on its own slide. Keep one issue, attached to that slide.
  const same = issues.find((x) => x.kind === kind && x.message === message && (x.slide === slide || x.slide === null));
  if (same) {
    if (same.slide === null) same.slide = slide;
    if (level === 'error') same.level = 'error';
    return same;
  }
  const issue = { level, kind, slide, message };
  issues.push(issue);
  return issue;
}

const ANSI = /\u001b\[[0-9;]*m/g;

// ---------------------------------------------------------------- level 1: render

function quartoRender(qmd, logFile, strict) {
  const args = ['render', qmd, '--log', logFile, '--log-format', 'json-stream'];
  const win = process.platform === 'win32';
  const quote = (s) => (win && /\s/.test(s) ? `"${s}"` : s);
  console.log(`> quarto ${args.join(' ')}`);
  const res = spawnSync('quarto', args.map(quote), { stdio: ['ignore', 'inherit', 'inherit'], shell: win });
  if (res.error) {
    const err = new Error(`cannot run quarto: ${res.error.message}`);
    err.environment = true;
    throw err;
  }
  // Quarto logs Lua filter warnings at INFO level with a "WARNING" prefix: match the text.
  if (fs.existsSync(logFile)) {
    for (const line of fs.readFileSync(logFile, 'utf8').split('\n')) {
      if (!line.trim()) continue;
      let entry;
      try { entry = JSON.parse(line); } catch { continue; }
      const msg = String(entry.msg ?? '').replace(ANSI, '').trim();
      const level = String(entry.levelName ?? '').toUpperCase();
      if (level === 'ERROR' || /^ERROR\b/.test(msg)) report('error', 'render', null, msg);
      else if (level.startsWith('WARN') || /^WARN(ING)?\b/.test(msg)) {
        report(strict ? 'error' : 'warning', 'render', null, msg);
      }
    }
  }
  if (res.status !== 0) report('error', 'render', null, `quarto render exited with status ${res.status}`);
  return res.status === 0;
}

// ---------------------------------------------------------------- static server

const MIME = {
  '.html': 'text/html; charset=utf-8', '.css': 'text/css', '.js': 'text/javascript',
  '.mjs': 'text/javascript', '.json': 'application/json', '.svg': 'image/svg+xml',
  '.png': 'image/png', '.jpg': 'image/jpeg', '.jpeg': 'image/jpeg', '.gif': 'image/gif',
  '.webp': 'image/webp', '.avif': 'image/avif', '.ico': 'image/x-icon', '.woff': 'font/woff',
  '.woff2': 'font/woff2', '.ttf': 'font/ttf', '.otf': 'font/otf', '.mp4': 'video/mp4',
  '.webm': 'video/webm', '.mp3': 'audio/mpeg', '.pdf': 'application/pdf', '.txt': 'text/plain',
  '.map': 'application/json', '.wasm': 'application/wasm',
};

function serve(root) {
  const server = http.createServer((req, res) => {
    let rel;
    try { rel = decodeURIComponent(new URL(req.url, 'http://x').pathname); } catch { rel = '/'; }
    if (rel === '/favicon.ico') { res.writeHead(204).end(); return; }
    const file = path.join(root, path.normalize(rel).replace(/^([/\\])+/, ''));
    if (!file.startsWith(root)) { res.writeHead(403).end(); return; }
    fs.stat(file, (err, st) => {
      const target = !err && st.isDirectory() ? path.join(file, 'index.html') : file;
      fs.readFile(target, (err2, data) => {
        if (err2) { res.writeHead(404).end('not found'); return; }
        res.writeHead(200, { 'content-type': MIME[path.extname(target).toLowerCase()] ?? 'application/octet-stream' });
        res.end(data);
      });
    });
  });
  return new Promise((resolve) => server.listen(0, '127.0.0.1', () => resolve(server)));
}

// ---------------------------------------------------------------- playwright

function loadPlaywright() {
  // createRequire honours NODE_PATH (global install in Claude cloud sessions) and the
  // repository's node_modules (`npm install --no-save playwright`), which ESM import does not.
  const bases = [import.meta.url, path.join(process.cwd(), 'noop.js')];
  for (const base of bases) {
    for (const name of ['playwright', 'playwright-core']) {
      try { return createRequire(base)(name); } catch { /* try next */ }
    }
  }
  const err = new Error('Playwright not found. Run `npm install --no-save playwright` then `npx playwright install chromium`.');
  err.environment = true;
  throw err;
}

const sleep = (ms) => new Promise((r) => setTimeout(r, ms));
const nextFrames = () => new Promise((r) => requestAnimationFrame(() => requestAnimationFrame(r)));

// Track the main frame's requests to wait until the network is quiet.
function trackMainRequests(page) {
  const inflight = new Set();
  const isMain = (req) => { try { return req.frame() === page.mainFrame(); } catch { return false; } };
  page.on('request', (r) => { if (isMain(r)) inflight.add(r); });
  page.on('requestfinished', (r) => inflight.delete(r));
  page.on('requestfailed', (r) => inflight.delete(r));
  return async function settle({ idle = 300, max = 10000 } = {}) {
    const start = Date.now();
    let quietSince = 0;
    while (Date.now() - start < max) {
      if (inflight.size === 0) {
        quietSince ||= Date.now();
        if (Date.now() - quietSince >= idle) return;
      } else quietSince = 0;
      await sleep(50);
    }
  };
}

async function openDeck(page, url) {
  await page.goto(url, { waitUntil: 'load', timeout: 60000 });
  await page.waitForFunction(() => window.Reveal && Reveal.isReady && Reveal.isReady(), null, { timeout: 30000 });
  await page.evaluate(() => document.fonts.ready);
  const size = await page.evaluate(() => {
    const c = Reveal.getConfig();
    return { width: Number(c.width) || 1280, height: Number(c.height) || 720 };
  });
  await page.setViewportSize(size);
  // The window has the slide size, as when presenting; the deck's margin is kept so that
  // overflowing content shows in the screenshots. No transitions or animations: final layout at once.
  await page.evaluate(() => Reveal.configure({
    transition: 'none', backgroundTransition: 'none', autoAnimate: false,
  }));
  return size;
}

async function listSlides(page) {
  return page.evaluate(() => Reveal.getSlides().map((s, i) => {
    const ix = Reveal.getIndices(s);
    const heading = s.querySelector('h1, h2, h3');
    let title = (heading?.textContent ?? '').replace(/\s+/g, ' ').trim();
    if (!title && s.id === 'title-slide') title = (s.querySelector('.title')?.textContent ?? '').trim();
    return {
      index: i,
      number: i + 1, // Quarto navigates linearly, so slides are numbered in order
      h: ix.h, v: ix.v ?? 0,
      id: s.id || '',
      title,
      iframe: s.getAttribute('data-background-iframe'),
    };
  }));
}

// Show a slide with all of its fragments, then wait for images, iframes, fonts and network.
async function showSlide(page, slide, settle) {
  await page.evaluate(({ h, v }) => Reveal.slide(h, v, 100000), slide);
  await page.evaluate(nextFrames);
  const iframes = await page.$$('.reveal .slides section.present iframe, .reveal .backgrounds .slide-background.present iframe');
  for (const handle of iframes) {
    const frame = await handle.contentFrame();
    if (!frame) continue;
    try {
      await frame.waitForLoadState('load', { timeout: 20000 });
    } catch {
      report('warning', 'browser', slide.index, `iframe did not finish loading in 20 s: ${frame.url()}`);
    }
  }
  await settle();
  await page.evaluate(async () => {
    const s = Reveal.getCurrentSlide();
    await Promise.all([...s.querySelectorAll('img')].map((img) => (img.complete ? null
      : new Promise((r) => { img.addEventListener('load', r, { once: true }); img.addEventListener('error', r, { once: true }); setTimeout(r, 10000); }))));
    await document.fonts.ready;
  });
  await page.evaluate(nextFrames);
  if (iframes.length) await sleep(1000); // let the iframe paint
}

// Level 3: content outside the slide box, broken images, code blocks that scroll.
async function inspectLayout(page) {
  return page.evaluate(() => {
    const s = Reveal.getCurrentSlide();
    const out = { overflow: [], scroll: [], broken: [] };
    for (const img of s.querySelectorAll('img')) {
      if (img.complete && img.naturalWidth === 0) out.broken.push(img.currentSrc || img.getAttribute('src') || '');
    }
    if (s.matches('.scrollable, .no-overflow-check')) return out;
    const box = Reveal.getSlidesElement().getBoundingClientRect();
    const scale = Reveal.getScale() || 1;
    const tol = 2;
    const describe = (el) => {
      let d = el.tagName.toLowerCase();
      if (el.id) d += `#${el.id}`;
      const cls = [...el.classList].filter((c) => !c.startsWith('quarto-')).slice(0, 2);
      if (cls.length) d += `.${cls.join('.')}`;
      const text = (el.textContent || '').replace(/\s+/g, ' ').trim().slice(0, 40);
      return text ? `${d} "${text}"` : d;
    };
    // Skip descendants of an element already reported. Inside an element that clips its
    // content (a code block), only look for scrolling: the clipped part is not visible.
    const reported = [];
    const clippers = [];
    for (const el of s.querySelectorAll('*')) {
      if (el.closest('.r-fit-text, .absolute, .no-overflow-check, aside.notes')) continue;
      if (reported.some((a) => a.contains(el))) continue;
      const cs = getComputedStyle(el);
      if (cs.display === 'none' || cs.visibility === 'hidden') continue;
      const clipped = clippers.some((a) => a.contains(el));
      const clips = cs.overflowX !== 'visible' || cs.overflowY !== 'visible';
      if (clips) clippers.push(el);
      const r = el.getBoundingClientRect();
      if (r.width === 0 && r.height === 0) continue;
      const by = {
        left: (box.left - r.left) / scale, right: (r.right - box.right) / scale,
        top: (box.top - r.top) / scale, bottom: (r.bottom - box.bottom) / scale,
      };
      const sides = clipped ? [] : Object.entries(by).filter(([, px]) => px > tol);
      if (sides.length) {
        reported.push(el);
        out.overflow.push({ element: describe(el), sides: sides.map(([side, px]) => `${side} +${Math.round(px)}px`) });
      } else if (clips && /auto|scroll/.test(cs.overflowX + cs.overflowY)) {
        const dirs = [];
        if (el.scrollWidth > el.clientWidth + tol) dirs.push(`horizontally +${el.scrollWidth - el.clientWidth}px`);
        if (el.scrollHeight > el.clientHeight + tol) dirs.push(`vertically +${el.scrollHeight - el.clientHeight}px`);
        if (dirs.length) out.scroll.push({ element: describe(el), dirs });
      }
    }
    return out;
  });
}

// Capture only the background (iframe) of the current slide, for the PDF.
async function captureBackground(page) {
  const style = await page.addStyleTag({ content: '.reveal > :not(.backgrounds) { visibility: hidden !important; }' });
  const png = await page.screenshot();
  await style.evaluate((el) => el.remove());
  return png;
}

// ---------------------------------------------------------------- PDF

const decodeEntities = (s) => s.replace(/&quot;/g, '"').replace(/&#39;/g, "'").replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&amp;/g, '&');

async function exportPdf(context, url, file, { fragments, iframeShots }) {
  const page = await context.newPage();
  await page.addInitScript(() => document.addEventListener('pdf-ready', () => { window.__pdfReady = true; }));
  // Print mode cannot render background iframes: swap them for the captures from the walk.
  const htmlPath = new URL(url).pathname;
  await page.route((u) => u.pathname === htmlPath, async (route) => {
    const response = await route.fetch();
    let body = await response.text();
    body = body.replace(/data-background-iframe="([^"]*)"/g, (m, src) => {
      const png = iframeShots.get(decodeEntities(src));
      return png ? `data-background-image="data:image/png;base64,${png.toString('base64')}"` : m;
    });
    await route.fulfill({ response, body });
  });
  const query = `?print-pdf${fragments ? '&pdfSeparateFragments=true' : ''}`;
  await page.goto(url + query, { waitUntil: 'networkidle', timeout: 60000 });
  await page.waitForFunction(() => window.__pdfReady || document.querySelectorAll('.pdf-page').length > 0, null, { timeout: 60000 });
  await page.evaluate(async () => {
    await document.fonts.ready;
    await Promise.all([...document.images].map((img) => (img.complete ? null
      : new Promise((r) => { img.addEventListener('load', r, { once: true }); img.addEventListener('error', r, { once: true }); setTimeout(r, 10000); }))));
  });
  await sleep(500);
  fs.mkdirSync(path.dirname(path.resolve(file)), { recursive: true });
  const pdf = await page.pdf({ path: file, preferCSSPageSize: true, printBackground: true });
  await page.close();
  // A slide taller than the page spills onto extra pages: count the pages in the file.
  return (pdf.toString('latin1').match(/\/Type\s*\/Page(?!s)/g) ?? []).length;
}

// ---------------------------------------------------------------- reports

function writeReports(outDir, meta, slides) {
  const bySlide = (i) => issues.filter((x) => x.slide === i);
  const global = issues.filter((x) => x.slide === null);
  const errors = issues.filter((x) => x.level === 'error').length;
  const warnings = issues.length - errors;
  const json = {
    ...meta, ok: errors === 0, errors, warnings,
    issues: global,
    slides: slides.map((s) => ({ ...s, issues: bySlide(s.index) })),
  };
  fs.writeFileSync(path.join(outDir, 'report.json'), JSON.stringify(json, null, 2));

  const esc = (t) => String(t).replace(/\|/g, '\\|').replace(/\n/g, ' ');
  const lines = [`## Slide check: ${errors ? 'FAILED' : 'passed'}`, '',
    `${meta.input}: ${slides.length} slides, ${errors} error(s), ${warnings} warning(s).`, ''];
  if (meta.pdf) lines.push(`PDF: \`${meta.pdf}\` (${meta.pdfPages} pages)`, '');
  if (issues.length) {
    lines.push('| Level | Slide | Check | Message |', '|---|---|---|---|');
    const label = (i) => {
      if (i === null) return '-';
      const s = slides[i];
      return esc(`${s.number}${s.title ? ` ${s.title}` : ''}`);
    };
    for (const x of [...global, ...slides.flatMap((s) => bySlide(s.index))]) {
      lines.push(`| ${x.level} | ${label(x.slide)} | ${x.kind} | ${esc(x.message)} |`);
    }
    lines.push('');
  }
  const md = lines.join('\n');
  fs.writeFileSync(path.join(outDir, 'report.md'), md);
  if (process.env.GITHUB_STEP_SUMMARY) fs.appendFileSync(process.env.GITHUB_STEP_SUMMARY, `${md}\n`);
  return { errors, warnings };
}

function printSummary(slides) {
  const label = (i) => {
    if (i === null) return '';
    const s = slides[i];
    return ` slide ${s.number}${s.title ? ` "${s.title}"` : ''}${s.id ? ` (#/${s.id})` : ''}`;
  };
  for (const x of issues) {
    console.log(`${x.level === 'error' ? 'ERROR' : 'WARN '} [${x.kind}]${label(x.slide)}: ${x.message}`);
  }
}

// ---------------------------------------------------------------- main

async function main() {
  let opts;
  try { opts = parseArgs(process.argv.slice(2)); } catch (e) {
    if (e instanceof UsageError) { console.error(`check-slides: ${e.message}\n\n${USAGE}`); return 2; }
    throw e;
  }
  if (opts.help) { console.log(USAGE); return 0; }

  const input = path.resolve(opts.input);
  if (!fs.existsSync(input)) { console.error(`check-slides: ${opts.input} not found`); return 2; }
  const isHtml = /\.html?$/i.test(input);
  const html = isHtml ? input : input.replace(/\.[^.]+$/, '.html');
  const outDir = path.resolve(opts.out);
  const shotsDir = path.join(outDir, 'slides');
  fs.mkdirSync(outDir, { recursive: true });
  if (opts.checks) {
    fs.rmSync(shotsDir, { recursive: true, force: true });
    fs.mkdirSync(shotsDir, { recursive: true });
  }

  // Level 1: render
  if (opts.render && !isHtml) {
    if (!quartoRender(input, path.join(outDir, 'render.log'), opts.strict && opts.checks)) {
      printSummary([]);
      writeReports(outDir, { input: opts.input }, []);
      return 1;
    }
  }
  if (!fs.existsSync(html)) {
    console.error(`check-slides: ${path.relative(process.cwd(), html)} not found; render first or drop --no-render`);
    return 2;
  }

  const { chromium } = loadPlaywright();
  const server = await serve(path.dirname(html));
  const url = `http://127.0.0.1:${server.address().port}/${encodeURIComponent(path.basename(html))}`;
  const origin = new URL(url).origin;
  const browser = await chromium.launch();
  let slides = [];
  const meta = { input: opts.input };
  try {
    const context = await browser.newContext({ viewport: { width: 1280, height: 720 } });
    const page = await context.newPage();
    let current = null; // slide index the issues belong to

    // Level 2: browser
    const failedUrls = new Map(); // url -> issue reported for it
    const fromMain = (req) => { try { return req.frame() === page.mainFrame(); } catch { return true; } };
    const onBadRequest = (req, why) => {
      if (new URL(req.url()).pathname === '/favicon.ico') return;
      // The deck's own resources and the iframe documents are errors; what a site
      // shown in an iframe fails to load is only a warning.
      const level = fromMain(req) || req.isNavigationRequest() ? 'error' : 'warning';
      const shown = req.url().startsWith(origin) ? req.url().slice(origin.length + 1) : req.url();
      failedUrls.set(req.url(), report(level, 'browser', current, `${why} ${shown}`));
    };
    page.on('response', (res) => { if (res.status() >= 400) onBadRequest(res.request(), `HTTP ${res.status()}`); });
    page.on('requestfailed', (req) => {
      const err = req.failure()?.errorText ?? 'failed';
      if (err.includes('ERR_ABORTED')) return; // revealjs unloads iframes and media when leaving a slide
      onBadRequest(req, `request failed (${err})`);
    });
    page.on('pageerror', (err) => report('error', 'browser', current, `JavaScript error: ${err.message}`));
    page.on('console', (msg) => {
      if (msg.type() !== 'error') return;
      const text = msg.text();
      if (text.startsWith('Failed to load resource')) return; // already reported by the network listeners
      const src = msg.location()?.url ?? '';
      const level = !src || src.startsWith(origin) ? 'error' : 'warning';
      report(level, 'browser', current, `console error: ${text}`);
    });
    const settle = trackMainRequests(page);

    await openDeck(page, url);
    slides = await listSlides(page);
    const iframeShots = new Map();
    const width = String(slides.length).length < 2 ? 2 : String(slides.length).length;

    for (const slide of slides) {
      if (!opts.checks && !slide.iframe) continue;
      current = slide.index;
      await showSlide(page, slide, settle);
      if (opts.checks) {
        const name = `${String(slide.index + 1).padStart(width, '0')}${slide.id ? `-${slide.id.replace(/[^\w-]+/g, '-')}` : ''}.png`;
        await page.screenshot({ path: path.join(shotsDir, name) });
        slide.screenshot = path.relative(outDir, path.join(shotsDir, name)).split(path.sep).join('/');
        // Level 3: layout
        const layout = await inspectLayout(page);
        for (const o of layout.overflow) report('error', 'layout', slide.index, `outside the slide (${o.sides.join(', ')}): ${o.element}`);
        for (const sc of layout.scroll) report('warning', 'layout', slide.index, `content scrolls ${sc.dirs.join(' and ')}: ${sc.element}`);
        for (const src of layout.broken) {
          const failed = failedUrls.get(new URL(src, url).href);
          // Images load with the page, before their slide is shown: move the network error to it.
          if (!failed) report('error', 'browser', slide.index, `broken image ${src}`);
          else if (failed.slide === null) failed.slide = slide.index;
        }
      }
      if (slide.iframe) iframeShots.set(slide.iframe, await captureBackground(page));
    }
    current = null;
    await page.close();

    if (opts.pdf) {
      const pdfPages = await exportPdf(context, url, opts.pdf, { fragments: opts.pdfFragments, iframeShots });
      meta.pdf = opts.pdf;
      meta.pdfPages = pdfPages;
      console.log(`PDF written to ${opts.pdf} (${pdfPages} pages)`);
    }
  } finally {
    await browser.close();
    server.close();
  }

  if (!opts.checks) return 0;
  printSummary(slides);
  const { errors, warnings } = writeReports(outDir, meta, slides);
  console.log(`\n${slides.length} slides checked: ${errors} error(s), ${warnings} warning(s). ` +
    `Screenshots and report in ${path.relative(process.cwd(), outDir) || '.'}`);
  return errors ? 1 : 0;
}

main().then(
  (code) => { process.exitCode = code; },
  (err) => {
    console.error(`check-slides: ${err.environment ? '' : 'unexpected error: '}${err.message}`);
    if (!err.environment) console.error(err.stack);
    process.exitCode = 2;
  },
);
