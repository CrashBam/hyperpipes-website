# HyperPipes — website

The public home page for **HyperPipes**. Plain HTML, CSS and a little JavaScript —
no build step, no framework, no npm. Open `index.html` in a browser and what you
see is exactly what goes live.

**Live at:** https://crashbam.github.io/hyperpipes-website/
*(after you do the one-time setup below)*

---

## One-time setup — turning on the free hosting

GitHub Pages hosts this for free, forever, on GitHub's own servers. No account
upgrade, no credit card, no other service needed.

1. Push this folder to GitHub (see *Publishing changes* below).
2. Go to **https://github.com/CrashBam/hyperpipes-website**
3. Click **Settings** (top row of the repo, on the right).
4. In the left sidebar click **Pages**.
5. Under **Build and deployment → Source**, choose **Deploy from a branch**.
6. Under **Branch**, pick **main** and folder **/ (root)**, then click **Save**.
7. Wait about a minute and refresh that page. It'll show a green banner with your
   address: **https://crashbam.github.io/hyperpipes-website/**

That's it. It stays live on its own.

### Want a shorter address?

Rename this repo to `CrashBam.github.io` (Settings → General → Repository name)
and the site moves to **https://crashbam.github.io/** — no folder on the end.
A real domain like `hyperpipes.com` is the only part that ever costs money: you'd
buy the name from a registrar, then point it here under Settings → Pages →
Custom domain. GitHub still does the hosting for free.

---

## Publishing changes

Every push to `main` republishes the site about a minute later.

```bash
cd "Godot Projects/hyperpipes-website"
git add -A
git commit -m "Update the site"
git push
```

If a change doesn't show up, it's almost always the browser's cache —
hard-refresh with **Cmd + Shift + R**.

---

## Adding screenshots

The gallery is deliberately easy to fill.

1. In the game, press **F2** (or **R3** on a pad) whenever something looks good.
   Shots save to `Pictures/HyperPipes`. Press **H** first to hide the HUD for a
   clean capture.
2. Copy the PNGs you like into this repo's `screenshots/` folder.
3. Open `index.html`, scroll to the bottom, and fill in the `SHOTS` list:

```js
const SHOTS = [
  { file: "screenshots/race-01.png", caption: "Neon Run — final lap" },
  { file: "screenshots/garage.png",  caption: "The garage" },
];
```

4. Commit and push.

While that list is empty the gallery draws stylised placeholder plates, so the
page never looks broken or half-finished.

**Keep them reasonably small.** A 1920×1080 PNG can be several MB; anything over
about 500 KB is worth shrinking. Quick way on a Mac:

```bash
sips -Z 1600 screenshots/*.png          # cap the long edge at 1600px
```

---

## What's in here

| Path | What it is |
| --- | --- |
| `index.html` | The whole page — every section, and the `SHOTS` list at the bottom |
| `assets/css/style.css` | All styling. Colours are the `--ice` / `--blue` / `--red` variables at the top, and the chamfered frame is the `--frame` SVG beside them |
| `assets/fonts/` | Orbitron and Exo 2, bundled so the site loads fast and looks right offline (OFL licence included) |
| `assets/img/icon.svg` | The game's app icon — used as the favicon and the logo |
| `assets/img/social-card.png` | The preview image shown when someone pastes the link into Discord, X or iMessage |
| `tools/social-card.html` | The source of that card. Edit it, then run `tools/render-card.sh` to re-make the PNG |
| `screenshots/` | Drop game screenshots here |
| `.nojekyll` | Tells GitHub Pages to serve the files exactly as they are |

## Editing the text

Everything is one file. Open `index.html` and look for the big comment banners
(`<!-- ==== hero ==== -->`, `<!-- ==== features ==== -->`, and so on). The
wording is ordinary HTML between the tags — change it, save, refresh the browser.

Colours live in one place: the `:root { ... }` block at the top of
`assets/css/style.css`. They were sampled straight off the Steam capsule PNGs —
`--ice` and `--blue` are the two lines of the frame, `--red` is the pipe's rings
— so changing one there changes it everywhere on the site.

The border style is one thing too: `--frame` holds a small inline SVG of the
double cut-corner outline, and `border-image` stretches it onto any box. To put
that frame on something new, add its selector to the two lists under
`--- the capsule frame ---`. `--fw` sets how big the corner cuts are, so small
controls (buttons, badges) turn it down.
