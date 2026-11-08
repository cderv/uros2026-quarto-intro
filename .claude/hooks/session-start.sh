#!/bin/bash
# Claude Code cloud sessions only: set up what the example bulletin and
# `just captures` need. Locally, follow .claude/CLAUDE.md instead.
set -euo pipefail

if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

cd "${CLAUDE_PROJECT_DIR:-.}"

# System library pdftools loads on Linux (CRAN binaries for Windows and macOS bundle it)
if ! dpkg -s libpoppler-cpp0t64 >/dev/null 2>&1; then
  apt-get update -qq
  apt-get install -y -qq libpoppler-cpp0t64
fi

# System libraries sf and units load for the bulletin map (CRAN binaries for Windows and macOS bundle them)
if ! dpkg -s libudunits2-0 libgdal34t64 libgeos-c1t64 libproj25 >/dev/null 2>&1; then
  apt-get update -qq
  apt-get install -y -qq libudunits2-0 libgdal34t64 libgeos-c1t64 libproj25
fi

# veraPDF: Quarto checks the PDF/A and PDF/UA standards with it at every render
if [ ! -d "$HOME/.local/share/quarto/verapdf" ]; then
  quarto install verapdf --no-prompt
fi

# R packages of the example, from example/rproj.lock, into example/.rvenv (gitignored).
# Only when the lock file changed since the last install that succeeded.
if command -v rig >/dev/null; then
  hashes=example/.rvenv/.session-start.sha256
  if ! sha256sum --check --status "$hashes" 2>/dev/null; then
    rm -f "$hashes"
    (cd example && rig proj sync)
    sha256sum .claude/hooks/session-start.sh example/rproj.toml example/rproj.lock > "$hashes" || rm -f "$hashes"
  fi
fi

# webshot2 (chromote) uses the Chromium that comes with Playwright in cloud sessions
if [ -n "${CLAUDE_ENV_FILE:-}" ] && [ -x /opt/pw-browsers/chromium ]; then
  echo 'export CHROMOTE_CHROME=/opt/pw-browsers/chromium' >> "$CLAUDE_ENV_FILE"
fi
