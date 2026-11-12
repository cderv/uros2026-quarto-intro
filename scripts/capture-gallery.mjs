#!/usr/bin/env node
// Screenshots of public Quarto publications for the "Already published with Quarto" slide.
// Captures the first screen (1280x800) of each page into images/gallery/, and checks
// that the page is made with Quarto (<meta name="generator" content="quarto-...">).
// Usage: node scripts/capture-gallery.mjs   (or: just gallery)
import { createRequire } from 'node:module';
import fs from 'node:fs';
import path from 'node:path';

const gallery = [
  ['01-insee-working-paper', 'https://inseefrlab.github.io/DT-tvcoef/'],
  ['02-agreste-dataviz', 'https://ssm-agriculture.github.io/site-DataViz/'],
  ['03-ons-weekly-deaths', 'https://onsdigital.github.io/weekly_deaths_data_explorer/'],
  ['04-nisra-childcare', 'https://nisra-explore.github.io/childcare-survey/'],
  ['05-ssb-documentation', 'https://doc.ameld.ssb.no/'],
  ['06-oecd-regional-profiles', 'https://oecd-cfe-eds.github.io/ro2023-country-pages/'],
  ['07-unece-oss', 'https://unece.github.io/OSS/'],
  ['08-jdemetra-docs', 'https://jdemetra-new-documentation.netlify.app/'],
];

function loadPlaywright() {
  // Same lookup as check-slides.mjs: NODE_PATH (Claude cloud) or the repository's node_modules
  for (const base of [import.meta.url, path.join(process.cwd(), 'noop.js')]) {
    for (const name of ['playwright', 'playwright-core']) {
      try { return createRequire(base)(name); } catch { /* try next */ }
    }
  }
  throw new Error('Playwright not found. Run `just setup`.');
}

const { chromium } = loadPlaywright();
const out = path.join('images', 'gallery');
fs.mkdirSync(out, { recursive: true });

const browser = await chromium.launch();
const page = await browser.newPage({ viewport: { width: 1280, height: 800 } });
let failed = 0;
for (const [name, url] of gallery) {
  try {
    await page.goto(url, { waitUntil: 'networkidle', timeout: 60000 });
    // Cookie banners hide the top of the page: refuse optional cookies when asked
    const reject = page.getByRole('button', { name: /reject|refuse|decline/i }).first();
    if (await reject.isVisible().catch(() => false)) await reject.click();
    await page.waitForTimeout(1500); // fonts, widgets, entrance animations
    const generator = await page.getAttribute('meta[name="generator"]', 'content').catch(() => null);
    await page.screenshot({ path: path.join(out, `${name}.png`) });
    const quarto = generator && generator.startsWith('quarto-');
    if (!quarto) failed++;
    console.log(`${quarto ? 'ok  ' : 'NOT QUARTO'} ${name}  ${generator ?? 'no generator tag'}  ${url}`);
  } catch (e) {
    failed++;
    console.log(`FAILED ${name}  ${url}  ${e.message.split('\n')[0]}`);
  }
}
await browser.close();
process.exit(failed ? 1 : 0);
