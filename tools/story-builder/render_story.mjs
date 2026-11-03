#!/usr/bin/env node
/**
 * render_story.mjs — record a built story HTML to MP4.
 *
 *   node tools/story-builder/render_story.mjs <story.html> <out.mp4> [--vertical] [--seconds N]
 *
 * Needs `playwright-core` (resolved from the repo, from NODE_PATH, or from PLAYWRIGHT_CORE_DIR),
 * a Chromium it can launch, and ffmpeg. Frames come from Chromium's own screencast, so no
 * Playwright-bundled ffmpeg is needed; the system ffmpeg assembles the MP4.
 *
 * Exit codes: 0 wrote the MP4 · 1 bad arguments · 2 no playwright-core or no browser (manual
 * steps printed) · 3 no ffmpeg (frames kept; the exact ffmpeg command printed).
 *
 * Browser lookup: PLAYWRIGHT_CHROMIUM_PATH (a Chromium or Chrome binary) → PLAYWRIGHT_CHANNEL
 * (e.g. "chrome") → playwright-core's own cached build → channel "chrome".
 * ffmpeg lookup: FFMPEG env → /opt/homebrew/bin/ffmpeg → /usr/local/bin/ffmpeg → PATH.
 *
 * --vertical records 1080×1920 with ?layout=vertical; the default is 1280×720 landscape.
 * --seconds defaults to the story's full loop (read from the HTML), capped at 120.
 */
import { createRequire } from 'node:module';
import { spawnSync } from 'node:child_process';
import path from 'node:path';
import fs from 'node:fs';
import os from 'node:os';
import { pathToFileURL } from 'node:url';

const argv = process.argv.slice(2);
const flags = { vertical: false, seconds: null };
const positional = [];
for (let i = 0; i < argv.length; i++) {
  const a = argv[i];
  if (a === '--vertical') flags.vertical = true;
  else if (a === '--seconds') flags.seconds = Number(argv[++i]);
  else if (a.startsWith('--seconds=')) flags.seconds = Number(a.slice(10));
  else if (a === '-h' || a === '--help') { usage(); process.exit(0); }
  else positional.push(a);
}
if (positional.length < 2) { usage(); process.exit(1); }
const storyPath = path.resolve(positional[0]);
const outPath = path.resolve(positional[1]);
if (!fs.existsSync(storyPath)) { console.error(`error: story not found: ${storyPath}`); process.exit(1); }

const width = flags.vertical ? 1080 : 1280;
const height = flags.vertical ? 1920 : 720;
const html = fs.readFileSync(storyPath, 'utf8');
const loopMatch = html.match(/const TOTAL_SECONDS = ([\d.]+);/);
const loopSeconds = loopMatch ? Number(loopMatch[1]) : 30;
const seconds = Math.min(120, Math.max(2, flags.seconds || Math.ceil(loopSeconds + 0.5)));
const url = pathToFileURL(storyPath).href + (flags.vertical ? '?layout=vertical' : '');
const FPS = 30;

function usage() {
  console.log('usage: node tools/story-builder/render_story.mjs <story.html> <out.mp4> [--vertical] [--seconds N]');
}

function manualSteps(reason) {
  console.error(`\n${reason}\n`);
  console.error(`Route A — install the recorder locally (no global install):
  npm i -D playwright-core            # in the repo, or in a scratch folder
  NODE_PATH=<that folder>/node_modules node tools/story-builder/render_story.mjs ${positional[0]} ${positional[1]}${flags.vertical ? ' --vertical' : ''} --seconds ${seconds}
  If its pinned Chromium is not downloaded, point at any Chromium or Chrome binary:
  PLAYWRIGHT_CHROMIUM_PATH="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"   # or PLAYWRIGHT_CHANNEL=chrome

Route B — record the screen by hand (macOS):
  1. Open ${url}
     in a browser window sized ${width}×${height}${flags.vertical ? ' (the vertical layout puts the caption above the phone)' : ''}.
  2. Press Shift-Cmd-5, choose "Record Selected Portion", draw the window, press Record; stop after ${seconds} s.
  3. Convert the .mov: ffmpeg -y -i recording.mov -c:v libx264 -pix_fmt yuv420p -movflags +faststart ${positional[1]}

Route C — ffmpeg screen capture (macOS, AVFoundation):
  ffmpeg -f avfoundation -list_devices true -i ""          # find the screen device index
  ffmpeg -y -f avfoundation -framerate 30 -i "1:none" -t ${seconds} -c:v libx264 -pix_fmt yuv420p ${positional[1]}
`);
}

function resolvePlaywright() {
  const bases = [import.meta.url, pathToFileURL(path.join(process.cwd(), 'package.json')).href];
  if (process.env.PLAYWRIGHT_CORE_DIR) bases.unshift(pathToFileURL(path.join(process.env.PLAYWRIGHT_CORE_DIR, 'package.json')).href);
  for (const base of bases) {
    try { return createRequire(base)('playwright-core'); } catch (e) { /* try the next base */ }
  }
  return null;
}

function findFfmpeg() {
  const candidates = [process.env.FFMPEG, '/opt/homebrew/bin/ffmpeg', '/usr/local/bin/ffmpeg', 'ffmpeg'].filter(Boolean);
  for (const c of candidates) {
    const r = spawnSync(c, ['-version'], { stdio: 'ignore' });
    if (r.status === 0) return c;
  }
  return null;
}

async function launch(pw) {
  const attempts = [];
  if (process.env.PLAYWRIGHT_CHROMIUM_PATH) attempts.push({ executablePath: process.env.PLAYWRIGHT_CHROMIUM_PATH });
  if (process.env.PLAYWRIGHT_CHANNEL) attempts.push({ channel: process.env.PLAYWRIGHT_CHANNEL });
  attempts.push({});
  attempts.push({ channel: 'chrome' });
  const errors = [];
  for (const opt of attempts) {
    try { return await pw.chromium.launch({ headless: true, ...opt }); }
    catch (e) { errors.push(`${JSON.stringify(opt)}: ${String(e.message).split('\n')[0]}`); }
  }
  throw new Error('no Chromium could be launched:\n  ' + errors.join('\n  '));
}

async function main() {
  const pw = resolvePlaywright();
  if (!pw) { manualSteps('playwright-core is not resolvable from this folder.'); process.exit(2); }
  let browser;
  try { browser = await launch(pw); }
  catch (e) { manualSteps(e.message); process.exit(2); }

  const tmp = fs.mkdtempSync(path.join(os.tmpdir(), 'ph-story-'));
  const context = await browser.newContext({ viewport: { width, height }, deviceScaleFactor: 1 });
  const page = await context.newPage();
  await page.goto(url, { waitUntil: 'load' });
  const beats = await page.evaluate(() => (window.__story ? window.__story.beats.length : 0));
  console.log(`recording ${beats} beats · ${width}×${height} · ${seconds} s …`);

  // Chromium screencast: one JPEG per repaint, with a timestamp; assembled below at a fixed frame rate.
  const cdp = await context.newCDPSession(page);
  const frames = [];
  cdp.on('Page.screencastFrame', ({ data, metadata, sessionId }) => {
    const file = path.join(tmp, `f${String(frames.length).padStart(6, '0')}.jpg`);
    fs.writeFileSync(file, Buffer.from(data, 'base64'));
    frames.push({ file, t: metadata.timestamp });
    cdp.send('Page.screencastFrameAck', { sessionId }).catch(() => {});
  });
  await page.evaluate(() => window.__story && window.__story.show(0));   // restart so the clip begins at beat 1
  await cdp.send('Page.startScreencast', { format: 'jpeg', quality: 92, maxWidth: width, maxHeight: height, everyNthFrame: 2 });
  const t0 = Date.now() / 1000;
  await page.waitForTimeout(seconds * 1000);
  await cdp.send('Page.stopScreencast').catch(() => {});
  await context.close();
  await browser.close();
  if (!frames.length) { console.error('no frames were captured'); process.exit(1); }

  // Concat list with real durations, then a constant-frame-rate H.264 MP4.
  const start = Math.min(frames[0].t, t0);
  const end = start + seconds;
  const list = ['ffconcat version 1.0'];
  frames.forEach((f, i) => {
    const next = i + 1 < frames.length ? frames[i + 1].t : end;
    list.push(`file '${path.basename(f.file)}'`, `duration ${Math.max(0.001, next - f.t).toFixed(4)}`);
  });
  list.push(`file '${path.basename(frames[frames.length - 1].file)}'`);
  const listPath = path.join(tmp, 'frames.txt');
  fs.writeFileSync(listPath, list.join('\n') + '\n');

  fs.mkdirSync(path.dirname(outPath), { recursive: true });
  const ffmpeg = findFfmpeg();
  const args = ['-y', '-loglevel', 'error', '-f', 'concat', '-safe', '0', '-i', listPath,
    '-vf', `scale=${width}:${height}:flags=lanczos,fps=${FPS}`, '-t', String(seconds),
    '-c:v', 'libx264', '-pix_fmt', 'yuv420p', '-movflags', '+faststart', outPath];
  if (!ffmpeg) {
    console.error(`ffmpeg not found; ${frames.length} frames kept in ${tmp}. Assemble with:\n  ffmpeg ${args.map(a => (/\s/.test(a) ? `"${a}"` : a)).join(' ')}`);
    process.exit(3);
  }
  const r = spawnSync(ffmpeg, args, { stdio: 'inherit' });
  if (r.status !== 0) { console.error(`ffmpeg failed; frames kept in ${tmp}`); process.exit(3); }
  fs.rmSync(tmp, { recursive: true, force: true });

  const probe = spawnSync(ffmpeg.replace(/ffmpeg$/, 'ffprobe'), ['-v', 'error', '-show_entries', 'format=duration',
    '-of', 'default=nw=1:nk=1', outPath], { encoding: 'utf8' });
  const dur = probe.status === 0 ? `${Number(probe.stdout).toFixed(1)} s` : 'duration unknown';
  console.log(`wrote ${outPath} (${dur}, ${width}×${height}, ${frames.length} captured frames)`);
}

main().catch(e => { console.error(e); process.exit(1); });
