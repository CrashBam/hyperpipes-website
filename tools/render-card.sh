#!/usr/bin/env bash
# Renders tools/social-card.html -> assets/img/social-card.png (1200x630).
# That PNG is what Discord/X/iMessage show when someone pastes the site link.
# Runs Chrome headless: no window opens.
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
chrome="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

[ -x "$chrome" ] || { echo "Google Chrome not found at $chrome"; exit 1; }

"$chrome" \
  --headless \
  --disable-gpu \
  --hide-scrollbars \
  --force-device-scale-factor=1 \
  --window-size=1200,630 \
  --screenshot="$root/assets/img/social-card.png" \
  "file://$root/tools/social-card.html" >/dev/null 2>&1

echo "Wrote assets/img/social-card.png"
