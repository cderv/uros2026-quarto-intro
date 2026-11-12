# IDE screenshots for the CLI slide

The slide "Quarto: a command line tool (CLI)" (`#render-cli` in `index.qmd`) shows the top of the
editor in Positron and RStudio with `bulletin.qmd` from the example repository open: the tab,
the toolbar with the Quarto button (Positron: **Preview**; RStudio: **Render**) and lines 1-4.
The frame around the button is CSS (`.hl-box`), not part of the image.

`just ide-captures` (script `scripts/capture-ide.sh`) drives both IDEs through their Chrome
DevTools port with agent-browser. It needs both IDEs already running with a debug port; this
file says how to launch them, then what to do with the output.

Tested on Windows 11 with Positron 2026.11.1 and RStudio Desktop 2026.11.0 daily. The macOS
commands below are untested.

## Requirements

- agent-browser (`npm i -g agent-browser`), ImageMagick (`magick`), bash (Git Bash on Windows).
- A clone of `cderv/uros2026-quarto-example` next to this repository
  (`../uros2026-quarto-example/bulletin.qmd`, or pass another path to the script).
- Positron, and an Electron build of RStudio Desktop (it accepts `--remote-debugging-port`).

## 1. Launch Positron in a capture profile

A separate profile leaves the everyday Positron untouched (theme, layout, extensions) and lets
the capture settings live in their own `settings.json`. Use two temporary folders:
`<profile>` (user data) and `<ext>` (extensions).

1. Write `<profile>/User/settings.json`:

   ```json
   {
     "window.zoomLevel": 3.8,
     "workbench.colorTheme": "Default Positron Light",
     "workbench.startupEditor": "none",
     "workbench.secondarySideBar.defaultVisibility": "hidden",
     "workbench.editor.decorations.badges": false,
     "workbench.editor.decorations.colors": false,
     "problems.decorations.enabled": false,
     "breadcrumbs.enabled": false,
     "editor.minimap.enabled": false,
     "git.blame.editorDecoration.enabled": false,
     "positron.importSettings.enable": false
   }
   ```

   `window.zoomLevel` 3.8 is 200 % (1.2^3.8) on a screen at 100 % scaling: the script checks
   that the page draws at 2 device pixels per CSS pixel and warns otherwise. On a screen
   already at 200 % (Retina), use 0.

2. Copy only the Quarto extension into `<ext>`: from `~/.positron/extensions/`, the folder
   `quarto.quarto-<version>`. Do not use `--disable-extensions`: the Quarto extension is not
   built in, so the file opens as plain text with no Preview button.

3. Launch with a debug port, the two folders and the file:

   ```bash
   Positron --remote-debugging-port=9222 --user-data-dir=<profile> --extensions-dir=<ext> <example>/bulletin.qmd
   ```

   On macOS (untested): `/Applications/Positron.app/Contents/MacOS/Positron` with the same flags.

4. Hide the panel and the primary side bar: command palette (Ctrl+Shift+P), `View: Hide Panel`,
   then `View: Close Primary Side Bar`. Over CDP:
   `agent-browser --cdp 9222 press Control+Shift+p`, `keyboard type "View: Hide Panel"`,
   `press Enter`.

## 2. Launch RStudio with a debug port

Quit RStudio, then relaunch it with `--remote-debugging-port=9223`. The script changes the
editor theme (Textmate), the zoom (2x) and the layout (source pane maximised) for the capture,
and restores all three on exit, also after an error. It opens `bulletin.qmd` without changing
project, so the R session is not restarted.

## 3. Capture

```bash
just ide-captures            # both; or: just ide-captures positron | rstudio
```

Outputs:

- `images/ide/positron-render-crop.png`, `images/ide/rstudio-render-crop.png`: crops at the
  1200x440 ratio, at 2x;
- `_check/ide/<ide>-full.png`: whole window, gitignored (it shows local paths and other
  projects: never commit it);
- on the terminal, one `.hl-box style="..."` line per IDE.

Copy each `style` into the matching `.hl-box` of `#render-cli` in `index.qmd`, run `just check`,
and look at the slide's screenshot in `_check/slides/` with the fragment shown.

## 4. Clean up

Close the Positron capture instance and delete `<profile>` and `<ext>`. Relaunch RStudio
without the flag if wanted.

## Pitfalls met while building the script

- **`ELECTRON_RUN_AS_NODE=1`** is inherited by shells started from VS Code (and so from Claude
  Code inside VS Code). Positron and RStudio then start as plain Node and fail with
  `bad option: --remote-debugging-port`. Unset it before launching.
- **The capture profile** (`--user-data-dir`) keeps the capture settings out of the everyday
  Positron and gives the same start every time. Whether Positron without it hands over to an
  already running instance was not tested.
- **Zoom shortcuts do nothing over CDP** (Ctrl+= in RStudio). Likely because key presses go to
  the page, not to the Electron menu that holds the zoom accelerators (not verified). RStudio:
  `.rs.api.executeCommand("zoomIn")` from the console; Positron: `window.zoomLevel`.
- **A window behind other windows does not draw**: the page reports
  `document.visibilityState` "hidden" and layout changes (pane zoom, console shown) wait for
  the next frame. The script forces one with a throwaway screenshot (`settle`).
- **Typing in the RStudio console**: Ctrl+2 can leave the focus in the editor, and the keys
  then land in the open document. The script focuses the console input and types only once it
  has the focus. If text ever lands in `bulletin.qmd`, close it without saving:
  `.rs.api.documentClose(id, save = FALSE)`; the file on disk is unchanged.
- **RStudio crop anchor**: other tabs (an empty `Untitled1`) can come before `bulletin.qmd`, so
  the crop starts at the editor's gutter, not at the tab.
- **RStudio "packages required but not installed" bar**: shown when the session library lacks
  the example's packages. The script dismisses it for the session (its close button), which
  keeps the layout; hiding it with CSS would leave a gap.
