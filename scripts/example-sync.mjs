#!/usr/bin/env node
// Keep example/ (git submodule) and the public repository cderv/uros2026-quarto-example in sync.
// The public repository is the source; the talk repository pins one of its commits.
//
//   node scripts/example-sync.mjs pull   (just example-pull)
//     Bring in the latest public commit: example/ on main at origin/main, new pin committed here.
//   node scripts/example-sync.mjs push   (just example-push)
//     Publish the commits made in example/ (on main), then commit the new pin here.
//
// Neither pushes the talk repository: push it yourself afterwards.
// Stops, changing nothing, when example/ has uncommitted changes or is not where it should be.
import { spawnSync } from 'node:child_process';
import fs from 'node:fs';

const SUB = 'example';
const BRANCH = 'main';
const UPSTREAM = `origin/${BRANCH}`;

function git(args, { dir = '.', capture = false, allowFail = false } = {}) {
  const r = spawnSync('git', ['-C', dir, ...args], {
    encoding: 'utf8',
    stdio: capture ? ['ignore', 'pipe', 'pipe'] : 'inherit',
  });
  if (r.status !== 0 && !allowFail) {
    if (capture) process.stderr.write(r.stderr || '');
    stop(`git ${args.join(' ')} failed in ${dir}/`);
  }
  return { ok: r.status === 0, out: (r.stdout || '').trim() };
}
const sub = (args, opts = {}) => git(args, { ...opts, dir: SUB });
const lines = (s) => (s ? s.split('\n') : []);

function stop(msg) {
  console.error(`\nexample-sync: ${msg}`);
  process.exit(1);
}

function ensureCheckedOut() {
  if (!fs.existsSync(`${SUB}/.git`)) git(['submodule', 'update', '--init', SUB]);
}

function ensureClean() {
  const dirty = sub(['status', '--porcelain'], { capture: true }).out;
  if (dirty) {
    stop(`example/ has uncommitted changes:\n${dirty}\n` +
      `Commit them in example/ (git -C example commit -am "..."), then run just example-push.`);
  }
}

function currentBranch() {
  return sub(['symbolic-ref', '--short', '-q', 'HEAD'], { capture: true, allowFail: true }).out;
}

function commitsIn(range) {
  return lines(sub(['log', '--oneline', range], { capture: true }).out);
}

// Commit the new pin of example/ in the talk repository, if it moved.
function commitPin() {
  const moved = !git(['diff', '--quiet', 'HEAD', '--', SUB], { allowFail: true, capture: true }).ok;
  if (!moved) {
    console.log('\nThe talk already pins this commit of the example: nothing to commit.');
    return;
  }
  const head = sub(['log', '-1', '--format=%h %s'], { capture: true }).out;
  git(['commit', '-q', '-m', `Pin the example to ${head}`, '--', SUB]);
  console.log(`\nCommitted the new pin in the talk repository: ${head}`);
  console.log('Push the talk repository when ready (git push).');
}

function pull() {
  ensureCheckedOut();
  ensureClean();
  sub(['fetch', '-q', 'origin']);
  const unpushed = commitsIn(`${UPSTREAM}..HEAD`);
  if (unpushed.length) {
    stop(`example/ has commits not in the public repository:\n${unpushed.join('\n')}\n` +
      'Publish them first with just example-push.');
  }
  const exists = sub(['rev-parse', '--verify', '-q', `refs/heads/${BRANCH}`],
    { capture: true, allowFail: true }).ok;
  if (exists) {
    const localOnly = commitsIn(`${UPSTREAM}..${BRANCH}`);
    if (localOnly.length) {
      stop(`the main branch of example/ has commits not in the public repository:\n` +
        `${localOnly.join('\n')}\nRun git -C example switch main, then just example-push.`);
    }
    sub(['switch', '-q', BRANCH]);
    sub(['merge', '-q', '--ff-only', UPSTREAM]);
  } else {
    sub(['switch', '-q', '-c', BRANCH, '--track', UPSTREAM]);
  }
  console.log(`example/ is on ${BRANCH} at ${sub(['log', '-1', '--format=%h %s'], { capture: true }).out}`);
  commitPin();
}

function push() {
  ensureCheckedOut();
  ensureClean();
  sub(['fetch', '-q', 'origin']);
  const branch = currentBranch();
  if (branch !== BRANCH) {
    const stray = commitsIn(`${UPSTREAM}..HEAD`);
    const hasMain = sub(['rev-parse', '--verify', '-q', `refs/heads/${BRANCH}`],
      { capture: true, allowFail: true }).ok;
    const onMain = hasMain ? commitsIn(`${UPSTREAM}..${BRANCH}`) : [];
    if (!stray.length && onMain.length) {
      stop(`example/ is not on ${BRANCH}, but ${BRANCH} has commits to publish:\n` +
        `${onMain.join('\n')}\nRun git -C example switch ${BRANCH}, then just example-push again.`);
    }
    if (!stray.length) {
      stop(`example/ is not on ${BRANCH} and has nothing to publish.\n` +
        `Before editing the bulletin, run just example-pull: it puts example/ on ${BRANCH}.`);
    }
    stop(`example/ is not on ${BRANCH}, so these commits are on no branch:\n${stray.join('\n')}\n` +
      `Move them to ${BRANCH}: git -C example switch ${BRANCH}, then ` +
      `git -C example cherry-pick <each commit above, oldest first>; run just example-push again.`);
  }
  const behind = commitsIn(`HEAD..${UPSTREAM}`);
  if (behind.length) {
    stop(`the public repository has commits example/ does not have:\n${behind.join('\n')}\n` +
      'Bring them in with git -C example pull --rebase, check the bulletin renders, ' +
      'then run just example-push again.');
  }
  const ahead = commitsIn(`${UPSTREAM}..HEAD`);
  if (ahead.length) {
    console.log(`Publishing to the public repository:\n${ahead.join('\n')}`);
    sub(['push', 'origin', BRANCH]);
  } else {
    console.log('The public repository already has every commit of example/.');
  }
  commitPin();
}

const cmd = process.argv[2];
if (cmd === 'pull') pull();
else if (cmd === 'push') push();
else stop('usage: node scripts/example-sync.mjs pull|push');
