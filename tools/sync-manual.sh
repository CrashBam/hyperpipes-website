#!/bin/bash
# Copies the manual out of the game repo into ../manual/ so the website serves
# the SAME document the PDFs are rendered from.
#
# The game repo's manual/README.md is emphatic about this: every control table
# in there is generated from Keybindings.Defs, because the hand-written first
# draft got four of them wrong. A separately written web manual would drift the
# same way, silently. So nothing here is authored — it is all copied, and this
# script is the only way the website's copy is allowed to change.
#
# Two mechanical edits are applied to the copied HTML, both re-runnable:
#   1. a screen-only stylesheet (manual.css is print CSS — A4, 9.6pt, white
#      paper — which is unreadable on a phone and jarring next to the site)
#   2. a "back to the manual index" bar, since a reader arriving from the web
#      has no other way out of a 19-page document
#
# manual-screen.css is website-owned and NOT overwritten. It is wrapped in
# @media screen so it cannot reach the PDFs.
#
# Usage:  ./tools/sync-manual.sh
set -euo pipefail
cd "$(dirname "$0")/.."

SRC="../HyperPipes/manual"
DST="manual"

if [ ! -d "$SRC" ]; then
	echo "Game repo manual not found at $SRC" >&2
	echo "Expected the game repo to be a sibling of this one." >&2
	exit 1
fi

# Refuse to publish a manual whose PDFs were never built — if the PDFs are
# missing, build.sh has not been run and generated/ may be stale too.
missing=0
for pdf in HyperPipes_Manual.pdf HyperPipes_Controls.pdf HyperPipes_QuickReference.pdf; do
	[ -f "$SRC/$pdf" ] || { echo "  missing: $SRC/$pdf" >&2; missing=1; }
done
if [ "$missing" = 1 ]; then
	echo "Run ./manual/build.sh in the game repo first." >&2
	exit 1
fi

mkdir -p "$DST/assets"

echo "Copying:"
for f in manual.html keybindings.html quickref.html manual.css \
         HyperPipes_Manual.pdf HyperPipes_Controls.pdf HyperPipes_QuickReference.pdf; do
	cp "$SRC/$f" "$DST/$f"
	echo "  $f"
done
# Only what the HTML actually references — the .import sidecars are Godot's and
# have no business on a web server.
cp "$SRC/assets/hyperpipes_title_clean.png" "$DST/assets/"
cp "$SRC/assets/Orbitron.ttf" "$SRC/assets/Exo2.ttf" "$SRC/assets/OFL_LICENSE.txt" "$DST/assets/"
echo "  assets/ (title art, 2 fonts, font licence)"

echo "Adapting for screen:"
python3 - "$DST" <<'PY'
import sys, pathlib, re

dst = pathlib.Path(sys.argv[1])

# A print document has no reason to carry a viewport tag, so the sources don't
# have one. Without it a phone lays the page out at a default ~980px and scales,
# which crops every paragraph mid-word. This is the single most important of the
# three edits — the screen stylesheet is cosmetic next to it.
VIEWPORT = '<meta name="viewport" content="width=device-width, initial-scale=1">'

SHEET = '<link rel="stylesheet" href="manual-screen.css">'
# Both links are RELATIVE on purpose. The site is served from two roots —
# crashbam.github.io/hyperpipes-website/ and hyperpipesgame.com — and an
# absolute "/" lands on the bare github.io domain from the first of those.
BAR = ('<nav class="webnav">'
       '<a href="./">← All manuals</a>'
       '<a href="../">HyperPipes home</a>'
       '</nav>')

for name in ("manual.html", "keybindings.html", "quickref.html"):
    p = dst / name
    html = p.read_text(encoding="utf-8")

    # Idempotent: re-running must not stack a second copy of any insert.
    if 'name="viewport"' not in html:
        html = html.replace('<meta charset="utf-8">',
                            '<meta charset="utf-8">\n' + VIEWPORT, 1)
    if SHEET not in html:
        html = html.replace('<link rel="stylesheet" href="manual.css">',
                            '<link rel="stylesheet" href="manual.css">\n' + SHEET, 1)
    if 'class="webnav"' not in html:
        html = re.sub(r'<body>', '<body>\n' + BAR, html, count=1)

    p.write_text(html, encoding="utf-8")
    print(f"  {name}")
PY

echo "Done. Commit and push to publish."
