# Artwork

Since 2026-10-02 copy, typography, layout and palette live in `Preview.config.json`; the canonical inputs are
`Preview-source.png` (the preserved illustration), `echo.png` (the line art) and `ModIcon-source.png`.

- `Mod/About/Preview.png` (896 x 504) is rendered from them by the shared renderer in `../scripts/` (its
  README gives the command). Diagnostics it writes go to `Art/.render/`, ignored by git.
- `Art/gallery/0-preview.png` is a byte-for-byte copy of `Mod/About/Preview.png`, recopied after each render:
  every Workshop gallery starts with it (owner's rule, PUBLISHING.md). The gallery pictures that follow (`1-`,
  `2-`, `3-`) come from `Tests/Pickle/Mod/Pickle/Features/07-galerie.feature`; see `PUBLICATION.md`.
- `Preview.ico`/`ModIcon.ico` are the local folder icons, outside `Mod/`.

Check the rendered Preview: contrast of every text against the real background, size under 1 MB, at 32 px for
the icon (`STYLE_RIMWORLD.md`).
