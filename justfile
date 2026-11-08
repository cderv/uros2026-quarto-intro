# uRos2026 talk: build, check and publish commands.

# Use PowerShell on Windows; recipes must stay cross-platform.
set windows-shell := ["pwsh.exe", "-NoLogo", "-Command"]

# Where the slides land once published
gh_url := "https://cderv.github.io/uros2026-quarto-intro/"
connect_url := "https://connect.posit.cloud/cderv/content/01a1b279-4973-fc02-0b87-7299cbd53f52"

# List available recipes
default:
    @just --list

# === slides ===

# Render the slides to index.html
[group('slides')]
render:
    quarto render index.qmd

# Live preview of the slides with auto-reload
[group('slides')]
preview:
    quarto preview index.qmd

# Check the deck: render (warnings are errors), browser errors, overflow; screenshots in _check/slides/
[group('slides')]
check:
    node scripts/check-slides.mjs --strict

# Export the deck to slides-full.pdf (for the organisers), without the checks
[group('slides')]
pdf:
    node scripts/check-slides.mjs --pdf-only

# Screenshot the public Quarto publications of the gallery slide into images/gallery/
[group('slides')]
gallery:
    node scripts/capture-gallery.mjs

# === example ===

# Install the example's R packages from example/rproj.lock (rig proj)
[group('example')]
example-deps:
    cd example && rig proj sync

# Render the example bulletin (HTML, PDF and Word from one source) to example/_output/
[group('example')]
example:
    quarto render example

# Rebuild the Word reference document (styles, logo, page) from example/_brand.yml
[group('example')]
reference-doc:
    cd example && Rscript brand/reference-doc.R

# Live preview of the example bulletin
[group('example')]
example-preview:
    quarto preview example

# Screenshot the rendered bulletin for the slides into images/bulletin/ (run `just example` first)
[group('example')]
captures:
    cd example && Rscript captures.R

# === dev ===

# Update the Quarto extensions in _extensions/ from their GitHub sources
[group('dev')]
extensions-update:
    quarto update grantmcdermott/clean --no-prompt
    quarto update quarto-ext/attribution --no-prompt
    quarto update emilhvitfeldt/quarto-revealjs-magic-move --no-prompt
    quarto update emilhvitfeldt/quarto-timeline --no-prompt
    quarto update emilhvitfeldt/quarto-revealjs-timing-bar --no-prompt
    quarto update jmbuhr/quarto-qrcode --no-prompt
    quarto update mcanouil/quarto-iconify --no-prompt
    quarto update emilhvitfeldt/quarto-easycarousel --no-prompt

# Update the agent skills listed in skills-lock.json
[group('dev')]
skills-update:
    npx -y skills update --project --yes

# Remove build artifacts
[group('dev')]
[unix]
clean:
    rm -rf index_files index.html _check .quarto example/_output example/.quarto

[group('dev')]
[windows]
clean:
    Remove-Item -Recurse -Force -ErrorAction SilentlyContinue index_files, index.html, _check, .quarto, example/_output, example/.quarto

# === publish ===

# Keep target selection inside just so it works in both shells.
# connect needs _publish.yml: --no-prompt only updates an existing target (see .claude/connect-cloud-preview.md).
_publish target:
    {{ if target == "gh" { "quarto publish gh-pages index.qmd --no-prompt --no-render" } else if target == "connect" { "quarto publish posit-connect-cloud index.qmd --no-prompt --no-render" } else { error("Unknown target: '" + target + "', use 'gh' or 'connect'") } }}
    @echo "Live at {{ if target == "gh" { gh_url } else { connect_url } }}"

# Check the deck, then publish the slides (gh: GitHub Pages, connect: Posit Connect Cloud)
[group('publish')]
[confirm("Publish the slides? This checks the deck, then publishes to the chosen target.")]
publish target="gh": check (_publish target)

# Publish without checking again (when `just check` already ran)
[group('publish')]
[confirm("Publish the slides (no re-check)?")]
publish-only target="gh": (_publish target)

# === programme analysis ===

# Install the R packages of the uRos programme analysis (rig proj, analysis/rproj.lock)
[group('analysis')]
analysis-deps:
    cd analysis && rig proj sync

# Rebuild the uRos programme data: fetch sources, parse, keyword flags, agreement and summaries
[group('analysis')]
analysis:
    cd analysis && Rscript R/01-fetch.R && Rscript R/02-extract.R && Rscript R/03-keywords.R && Rscript R/04-agreement.R && Rscript R/05-summarise.R
