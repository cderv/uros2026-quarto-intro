#!/usr/bin/env bash
# Screenshots of the editor in Positron and RStudio for the "Quarto: a command line tool (CLI)"
# slide (#render-cli): the bulletin.qmd tab, the toolbar with the Quarto button, lines 1-4.
#
# Drives each IDE through its Chrome DevTools port with agent-browser. Both IDEs must already
# be running with a debug port and bulletin.qmd open in Positron: see .claude/ide-captures.md.
#
# Writes images/ide/<ide>-render-crop.png (crop at the 1200x440 ratio, 2x pixels) and
# _check/ide/<ide>-full.png (whole window, gitignored), then prints the frame position
# around the button, in % of the crop, for the .hl-box in index.qmd.
#
# RStudio settings changed for the capture (editor theme, zoom, maximised source pane) are
# restored on exit, even after an error.
#
# Usage: scripts/capture-ide.sh [positron|rstudio|all] [path/to/bulletin.qmd]
#        (or: just ide-captures)
# Env:   POSITRON_PORT (9222), RSTUDIO_PORT (9223)
set -euo pipefail
export MSYS_NO_PATHCONV=1  # Git Bash: keep JS and R strings that contain "/" untouched

which_ide="${1:-all}"
qmd="${2:-../uros2026-quarto-example/bulletin.qmd}"
positron_port="${POSITRON_PORT:-9222}"
rstudio_port="${RSTUDIO_PORT:-9223}"
ratio_w=1200 ratio_h=440
out_dir=images/ide full_dir=_check/ide
mkdir -p "$out_dir" "$full_dir"

command -v agent-browser >/dev/null || { echo "agent-browser not found (npm i -g agent-browser)" >&2; exit 2; }
command -v magick >/dev/null || { echo "ImageMagick (magick) not found" >&2; exit 2; }

# agent-browser against one port, without its browser-version warnings
ab() { local port=$1; shift; agent-browser --cdp "$port" "$@" 2> >(grep -v -E 'behind the current|relaunched' >&2); }
# eval and strip the JSON quotes around a string result
ab_eval() { ab "$1" eval "$2" | tail -n 1 | sed -e 's/^"//' -e 's/"$//'; }

# Make the window draw a frame. An IDE window behind other windows reports
# document.visibilityState "hidden" and draws nothing, so layout changes (pane zoom, console
# shown) wait; a screenshot forces a frame.
settle() { ab "$1" screenshot "$full_dir/.settle.png" >/dev/null; }

# Run one R command in the RStudio console. Ctrl+2 shows the console (with a zoomed source
# pane, it zooms the console instead) but can leave the focus in the editor: focus the
# console input explicitly, and type only once it has focus, else the keystrokes land in the
# open document.
r_console() {
  ab "$rstudio_port" press Control+2 >/dev/null
  settle "$rstudio_port"
  local tries=0
  until [ "$(ab_eval "$rstudio_port" '(() => {
      const t = document.querySelector("#rstudio_console_input textarea");
      if (t) t.focus();
      return !!document.activeElement.closest("#rstudio_console_input");
    })()')" = true ]; do
    tries=$((tries + 1))
    [ "$tries" -le 10 ] || { echo "RStudio: the console never got focus, not typing: $1" >&2; return 1; }
    ab "$rstudio_port" wait 300 >/dev/null
    settle "$rstudio_port"
  done
  ab "$rstudio_port" keyboard type "$1" >/dev/null
  ab "$rstudio_port" press Enter >/dev/null
  ab "$rstudio_port" wait "${2:-1500}" >/dev/null
  settle "$rstudio_port"
}

# Crop the full screenshot and print the frame. $2 is the measure, in CSS pixels:
# "editorLeft tabTop line4Bottom btnX btnY btnW btnH dpr"
crop_and_report() {
  local ide=$1 full="$full_dir/$1-full.png" out="$out_dir/$1-render-crop.png"
  read -r tab_x tab_y line_b btn_x btn_y btn_w btn_h dpr <<<"$2"
  # crop: from the editor's left edge and just above the tab down to line 4, widened to the 1200x440 ratio
  awk -v tx="$tab_x" -v ty="$tab_y" -v lb="$line_b" -v bx="$btn_x" -v by="$btn_y" \
      -v bw="$btn_w" -v bh="$btn_h" -v d="$dpr" -v rw="$ratio_w" -v rh="$ratio_h" \
      -v ide="$ide" -v full="$full" -v out="$out" 'BEGIN {
    x = tx * d; y = (ty - 6) * d; h = (lb + 3) * d - y; w = h * rw / rh;
    x = int(x + 0.5); y = int(y + 0.5); h = int(h + 0.5); w = int(w + 0.5);
    # frame around the button, in % of the crop: 6 CSS px of margin on the sides, 2 above and
    # below (line 1 starts right under the toolbar); the frame border is drawn inside it
    mx = 6; my = 2;
    fx = ((bx - mx) * d - x) / w * 100; fy = ((by - my) * d - y) / h * 100;
    fw = (bw + 2 * mx) * d / w * 100;   fh = (bh + 2 * my) * d / h * 100;
    printf "%dx%d+%d+%d\n", w, h, x, y > "/dev/stderr";
    printf "%s: %s (%dx%d)\n  .hl-box style=\"left: %.1f%%; top: %.1f%%; width: %.1f%%; height: %.1f%%;\"\n",
      ide, out, w, h, fx, fy, fw, fh;
  }' 2>"$full_dir/$ide-geometry.txt"
  magick "$full" -crop "$(cat "$full_dir/$ide-geometry.txt")" +repage "$out"
}

capture_positron() {
  local p=$positron_port
  ab_eval "$p" 'document.title' | grep -q 'bulletin.qmd' \
    || { echo "Positron (port $p): open bulletin.qmd first (see .claude/ide-captures.md)" >&2; return 1; }
  settle "$p"
  local measure
  measure=$(ab_eval "$p" '(() => {
    const box = e => e.getBoundingClientRect();
    const tab = box(document.querySelector(".tabs-container .tab.active"));
    const icon = box(document.querySelector(".codicon-run-all").closest(".action-bar-button"));
    const label = [...document.querySelectorAll(".action-bar-button")]
      .find(e => e.textContent.trim() === "Preview");
    if (!label) throw new Error("no Preview button: is the Quarto extension enabled?");
    const lab = box(label);
    const lines = [...document.querySelectorAll(".view-line")].map(box).sort((a, b) => a.top - b.top);
    const x0 = Math.min(icon.left, lab.left), x1 = Math.max(icon.right, lab.right);
    const y0 = Math.min(icon.top, lab.top),  y1 = Math.max(icon.bottom, lab.bottom);
    return [tab.left, tab.top, lines[3].bottom, x0, y0, x1 - x0, y1 - y0, devicePixelRatio].join(" ");
  })()')
  check_measure Positron "$measure"
  local dpr=${measure##* }
  awk -v d="$dpr" 'BEGIN { exit !(d > 1.9 && d < 2.1) }' \
    || echo "warning: Positron pixel ratio is $dpr, not 2: set window.zoomLevel in the capture profile" >&2
  ab "$p" screenshot "$full_dir/positron-full.png" >/dev/null
  crop_and_report positron "$measure"
}

# RStudio state to put back, filled in by capture_rstudio
rstudio_theme="" rstudio_zoom_steps=0
restore_rstudio() {
  echo "Restoring RStudio: theme '$rstudio_theme', $rstudio_zoom_steps zoom step(s) back, source pane unzoomed" >&2
  r_console '.rs.api.executeCommand("layoutEndZoom")'
  if [ "$rstudio_zoom_steps" -gt 0 ]; then
    r_console "for (i in seq_len($rstudio_zoom_steps)) .rs.api.executeCommand(\"zoomOut\")"
  fi
  r_console ".rs.api.applyTheme(\"$rstudio_theme\")" 3000
}

# "n n n n n n n n": the measure must be 8 numbers, else the page did not match the selectors
check_measure() {
  [[ "$2" =~ ^(-?[0-9.]+\ ){7}[0-9.]+$ ]] || { echo "$1: unexpected measure: $2" >&2; return 1; }
}

capture_rstudio() {
  local p=$rstudio_port theme_file theme_file_r
  theme_file=$(mktemp)
  theme_file_r=$(cygpath -m "$theme_file" 2>/dev/null || echo "$theme_file")

  # remember the editor theme, then restore everything on exit, also after an error
  r_console "writeLines(.rs.api.getThemeInfo()\$editor, \"$theme_file_r\")"
  rstudio_theme=$(cat "$theme_file"); rm -f "$theme_file"
  [ -n "$rstudio_theme" ] || { echo "RStudio (port $p): could not read the editor theme" >&2; return 1; }
  trap restore_rstudio EXIT

  local qmd_r
  qmd_r=$(cygpath -m "$(realpath "$qmd")" 2>/dev/null || realpath "$qmd")
  r_console '.rs.api.applyTheme("Textmate (default)")' 3000
  r_console ".rs.api.navigateToFile(\"$qmd_r\", 1, 1)" 3000
  # zoom until the page draws at 2 device pixels per CSS pixel (RStudio zoom steps: ... 1.75, 2)
  while awk -v d="$(ab_eval "$p" 'devicePixelRatio')" 'BEGIN { exit !(d < 1.95) }'; do
    [ "$rstudio_zoom_steps" -lt 8 ] || { echo "RStudio: zoom did not reach 2x" >&2; return 1; }
    r_console '.rs.api.executeCommand("zoomIn")' 800
    rstudio_zoom_steps=$((rstudio_zoom_steps + 1))
  done
  r_console '.rs.api.executeCommand("layoutZoomSource")' 2000

  # session-only cleanup of the editor: close the "packages not installed" bar, hide the
  # whitespace markers (a style in the page, gone at the next reload; no preference changed)
  ab_eval "$p" '(() => {
    const bar = document.querySelector("[aria-label=\"Dismiss infobar\"], [title=\"Dismiss infobar\"]");
    if (bar) bar.click();
    const s = document.createElement("style");
    s.textContent = ".ace_invisible { opacity: 0 !important; }";
    document.head.appendChild(s);
    return "ok";
  })()' >/dev/null
  ab "$p" wait 800 >/dev/null
  settle "$p"

  local measure
  measure=$(ab_eval "$p" '(() => {
    const box = e => e.getBoundingClientRect();
    const tab = [...document.querySelectorAll(".rstheme_tabLayoutCenter")]
      .find(e => e.textContent.includes("bulletin.qmd") && box(e).width > 0);
    const label = [...document.querySelectorAll("div")]
      .find(e => e.textContent === "Render" && e.children.length === 0 && box(e).width > 0);
    if (!tab || !label) throw new Error("no bulletin.qmd tab or Render button");
    const btn = box(label.closest("tr"));
    const lines = [...document.querySelectorAll(".ace_line")].map(box)
      .filter(b => b.height > 0 && b.left < innerWidth / 2).sort((a, b) => a.top - b.top);
    // left edge: the line-number gutter, as other tabs (Untitled1...) may come before bulletin.qmd
    const gutter = [...document.querySelectorAll(".ace_gutter")].map(box)
      .filter(b => b.width > 0 && b.left < innerWidth / 2).sort((a, b) => a.left - b.left)[0];
    return [gutter.left, box(tab).top, lines[3].bottom, btn.left, btn.top, btn.width, btn.height,
            devicePixelRatio].join(" ");
  })()')
  check_measure RStudio "$measure"
  ab "$p" screenshot "$full_dir/rstudio-full.png" >/dev/null
  crop_and_report rstudio "$measure"
  restore_rstudio
  trap - EXIT
}

case "$which_ide" in
  positron) capture_positron ;;
  rstudio)  capture_rstudio ;;
  all)      capture_positron; capture_rstudio ;;
  *) echo "usage: $0 [positron|rstudio|all] [path/to/bulletin.qmd]" >&2; exit 2 ;;
esac
