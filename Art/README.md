# Artwork

- `Preview-source.png` is the preserved original illustration. `Preview.png` is a byte-for-byte copy of
  it under the name `../scripts/Render-Preview.cjs` reads.
- `Mod/About/Preview.png` (896 x 504) is `Preview.png` composited with the title, tag, summary, version
  badge and, since 2026-09-29, the cut-out ModIcon, by `../scripts/Render-Preview.cjs` reading
  `preview-copy.json` and `preview-palette.json`.
- `ModIcon-badge.png` is `Mod/About/ModIcon.png`'s background flood-filled out and alpha-trimmed, made
  once by `../scripts/Make-PreviewBadge.ps1 -SaveTrimmedIconTo Art/ModIcon-badge.png` (re-run only if
  ModIcon.png changes). It sits bottom-right (`preview-copy.json`'s `iconBadge.corner`), -15deg: the
  top-right corner already carries the "1.6" version triangle.
- `Art/steam/00-Preview.png` is a byte-for-byte copy of `Mod/About/Preview.png`, recopied by hand after
  each render (the shared script does not do this itself): every Workshop gallery starts with it
  (owner's rule, PUBLISHING.md). No further gallery images exist yet.
- `Preview.ico`/`ModIcon.ico` are the local folder icons, outside `Mod/`.

Run `node ../scripts/Render-Preview.cjs bottom-right` from this repo's root after any change to the
illustration, the palette, the copy text or the icon badge, then `uv run --with pillow python
Art/verify-preview.py` (contrast ratios against the real rendered background, size under 900 KB,
writes `Preview-thumbnail-qa.png`), then recopy `Mod/About/Preview.png` to `Art/steam/00-Preview.png`.
