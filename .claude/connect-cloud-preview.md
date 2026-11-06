# Previews on Posit Connect Cloud

Each version of the deck can be reviewed before the public gh-pages release: once set up, the
GitHub workflow publishes every push whose check passes to one Posit Connect Cloud content item
(all branches share it, so the latest push wins). The content stays private only on the Enhanced
plan and above, where public access is off by default; on Free and Basic it is always public.

One-time setup, done by Christophe on his own machine (never in a cloud session, never in chat):

1. `quarto publish posit-connect-cloud index.qmd`: Quarto renders the deck, asks to authorize
   (browser login), creates the content and writes `_publish.yml`. `just publish connect` cannot do
   this first run: like raukr-2026-quarto, it passes `--no-prompt`, which only updates an existing
   target. On connect.posit.cloud, check that public access is off for the content.
2. Commit and push `_publish.yml` (only the content id and URL, no credentials), and set
   `connect_url` in the `justfile` to that URL. Done for this talk: the preview lives at
   <https://connect.posit.cloud/cderv/content/01a1b279-4973-fc02-0b87-7299cbd53f52>.
3. Copy the production `accessToken` and `refreshToken` from Quarto's token store,
   `publish/accounts/posit-connect-cloud/accounts.json` in the Quarto data directory, into the
   repository secrets `POSIT_CONNECT_CLOUD_ACCESS_TOKEN` and `POSIT_CONNECT_CLOUD_REFRESH_TOKEN`.
   These commands send the values straight to GitHub without printing them; the shell history
   keeps the expressions, not the tokens. Windows (PowerShell):

   ```powershell
   $f = Join-Path $env:LOCALAPPDATA 'quarto\publish\accounts\posit-connect-cloud\accounts.json'
   $acc = @(Get-Content $f -Raw | ConvertFrom-Json) | Where-Object environment -eq 'production' | Select-Object -First 1
   $acc | Select-Object accountName, accountId, environment   # check the account, no secrets shown
   gh secret set POSIT_CONNECT_CLOUD_ACCESS_TOKEN --repo cderv/uros2026-quarto-intro --body $acc.accessToken
   gh secret set POSIT_CONNECT_CLOUD_REFRESH_TOKEN --repo cderv/uros2026-quarto-intro --body $acc.refreshToken
   gh secret list --repo cderv/uros2026-quarto-intro           # names and dates only
   ```

   macOS and Linux (needs `jq`; on Linux the file is under `~/.local/share/quarto`):

   ```bash
   f="$HOME/Library/Application Support/quarto/publish/accounts/posit-connect-cloud/accounts.json"
   acc='[.[] | select(.environment == "production")][0]'
   jq -r "$acc | \"\(.accountName) \(.accountId) \(.environment)\"" "$f"
   gh secret set POSIT_CONNECT_CLOUD_ACCESS_TOKEN --repo cderv/uros2026-quarto-intro --body "$(jq -r "$acc.accessToken" "$f")"
   gh secret set POSIT_CONNECT_CLOUD_REFRESH_TOKEN --repo cderv/uros2026-quarto-intro --body "$(jq -r "$acc.refreshToken" "$f")"
   gh secret list --repo cderv/uros2026-quarto-intro
   ```

   Set `POSIT_CONNECT_CLOUD_ACCOUNT_ID` (from `accountId`) only with several Connect Cloud accounts.

The publish step is skipped while a secret or `_publish.yml` is missing. Quarto refreshes the
access token in memory only, so if the step later fails with 401, run the command of step 1 again
(it republishes to the same content) and the commands of step 3.

`resources: [images/]` in `index.qmd` is required: `quarto publish --no-render` bundles only
`index.html`, `index_files/` and declared resources, for both gh-pages and Connect Cloud.
