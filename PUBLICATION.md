# Publication notes — Nelim's Animals, Naturally

The Workshop item exists since the 0.1.0 prepublication (2026-10-01): id `3811381865`, private, `About/PublishedFileId.txt` committed in e656137. Replace `<THIS_MOD_ID>` below with it only once the item is public. Publishing goes through GitHub Actions per `AGENTS.md`/`Rimworld-Release-Admin/docs/OPERATIONS.md`;
this file only prepares what needs the item's own ID, filled in once it exists.

## Steam description

Single source (PUBLISHING.md, "Description : UN SEUL COUP"): English Markdown, no code fence inside the block. The `<description>` of
`Mod/About/About.xml` is generated from it by `sync-about-description.mjs` at `writeDocs`; it is **not** synced yet, so the two differ
until then (the About.xml text still says "a macaw lives for 55 years", which `Lifespan.xml` does not write: fixed below).
Figures checked against the patches on 2026-10-10 (`TEST_SCENARIOS.md`, "Figures checked").

```markdown
Rebalances animals against one another using biological reference values.

Every value is derived from a single physical anchor: the species' real mass in kilograms.

- **Body size**: the cube root of mass relative to a 70 kg human.
- **Lifespan**: allometric laws calibrated by clade. A chicken lives for 7 years, a cockatoo from an animal pack for 52: birds do not follow one curve.
- **Growth, reproduction, productivity**: maturity age, gestation, litter size, milk, wool and eggs follow the same mass.
- **Circadian rhythm**: nocturnal, crepuscular and cathemeral animals get their real body clock, through the Nocturnal Animals extension.
- **Hard rules**: retaliation is at least as likely as taming failure; trainable animals do not escape their pens; maximum prey size accounts for the hunting method.
- **Hybridisation**: groups derived from real taxonomy, in Dogs Mate format.
- **Forage** (only with Vanilla Expanded Framework): animals that Animals Forage (Continued) does not cover dig for food when hungry.

Precautionary rule: a value changes only when it differs from its target by more than 15 percent. Ludeon's existing hand-tuning is not overwritten when it is already close, deliberately oversized creatures keep their intended size, and apex predators keep the maxPreyBodySize = 99999 sentinel.

All patches are conditional: removing an animal mod simply makes its corresponding patches inert, without load errors.

Requires [[XND] Nocturnal Animals (Continued)](https://steamcommunity.com/sharedfiles/filedetails/?id=2269731409). Load AFTER all animal mods.

**IF I GO QUIET**: If I do not answer within a reasonable time after being contacted, anyone may freely update this or any other of my mods, including publishing a continuation of it. All credit must be preserved.

**AI-GENERATED**: Claude (Anthropic) and Codex (OpenAI) assisted with the XML patches, tests, documentation and audit maintenance. The values and rules are mine.

**THANKS**: Ludeon Studios and the authors of the animal mods whose definitions are targeted. [[XND] Nocturnal Animals (Continued)](https://steamcommunity.com/sharedfiles/filedetails/?id=2269731409) by Mlie, from the original [[XND] Nocturnal Animals](https://steamcommunity.com/sharedfiles/filedetails/?id=2004368312) by XeoNovaDan, whose bodyClock extension this mod uses. [Animals Forage (Continued)](https://steamcommunity.com/sharedfiles/filedetails/?id=3667046888) by Mlie, [Alpha Animals](https://steamcommunity.com/sharedfiles/filedetails/?id=1541721856) by Sarg Bjornson and [Vanilla Animals Expanded](https://steamcommunity.com/sharedfiles/filedetails/?id=2871933948) by Oskar Potocki, whose animals the forage patches extend. [Vanilla Expanded Framework](https://steamcommunity.com/sharedfiles/filedetails/?id=2023507013) provides the forage components. Development only, never a dependency: [Pickle](https://steamcommunity.com/sharedfiles/filedetails/?id=3791648678), [RimLogging](https://steamcommunity.com/sharedfiles/filedetails/?id=3733484696) and PickleTools.

See ATTRIBUTION.md and the MIT License in the GitHub repository.

[Source code on GitHub](https://github.com/vbardales/Rimworld-Nelim-Animals-Naturally)
```

Open points for this block, none decided here:

- Dogs Mate, Some Like It Rotten and Zoology are `loadAfter` only (no XPath targets them), so they are not thanked here; `PUBLISHING.md` asks every named, claimed or really exercised integration to be thanked, and a dedicated pass does stage all three. Whether they belong in `THANKS` is Virginie's call.
- Vanilla Animals Expanded - Royal Animals (2858079457) is now staged by the `avec-vef` pass (VAERoy); it is not in `THANKS` yet.
- The "54 vanilla species, 7 percent median error" sentence of the old description is dropped: it comes from the generator, which is not in this repository, and cannot be checked from `Mod/`.

## Thanks to post, after the item is public

`../WORKSHOP_COMMENTS.md` is the shared register: read it first, one main comment per recipient page
across the whole collection. Rows already added or updated for this mod on 2026-09-29 (see that file's
own history for the exact diff):

| Recipient | Workshop id | Register today | What to do |
| --- | --- | --- | --- |
| [XND] Nocturnal Animals (Continued) | `2269731409` | `posted` | added to `Covers`, post nothing (hard dependency, no new mechanic to credit beyond what's already thanked) |
| Vanilla Expanded Framework | `2023507013` | `posted` | added to `Covers`, post nothing |
| Pickle | `3791648678` | `posted` | added to `Covers`, post nothing (development/test tool) |
| RimLogging | `3733484696` | `posted` | added to `Covers`, post nothing |
| PickleTools | `3806142401` | `not_applicable` | added to `Covers` anyway per the existing convention (the author's own project) |
| Animals Forage (Continued), Mlie | `3667046888` | `drafted` | post the first draft below once this mod's own item is public |
| Alpha Animals, Sarg Bjornson | `1541721856` | `drafted` | second draft |
| Vanilla Animals Expanded, Oskar Potocki | `2871933948` | `drafted` | third draft |

**Deliberately not drafted:** Dogs Mate (`2441132298`), Some Like It Rotten (`2503519676`), Zoology
(`3679396881`). All three are `<loadAfter>` only — `TESTING.md` confirmed on 2026-09-28 that no XPath of
this mod targets any of them (Hybridation.xml writes the *vanilla* `canCrossBreedWith` field, not their
defs). Per the register's own rule, "post only where the mod is really used or covered" — a load-order
declaration with zero patches doesn't clear that bar. Dogs Mate already has a `drafted` row from Moa
Renew for a genuinely shared mechanism (the vanilla crossbreeding lists); nothing is added here to it.
Revisit only if a future patch actually targets one of the three.

Each draft below needs `[url=https://steamcommunity.com/sharedfiles/filedetails/?id=<THIS_MOD_ID>]Nelim's Animals, Naturally[/url]`
with `<THIS_MOD_ID>` filled in once the Workshop item exists — the placeholder is left as `<THIS_MOD_ID>`
on purpose, do not post with it still in place. Read the page's last comments again before posting
(WORKSHOP_COMMENTS.md's method), in case the tone has moved since 2026-09-29.

**Mlie, on Animals Forage (Continued)** (289 characters):

> Your list of who already forages (grizzly bears -> berries, ducks -> fish) turned out to be the
> perfect map of who still needed it. My rebalance mod hands the same comp to animals your patch
> hadn't reached yet, no overlap. Thanks for laying the groundwork :)
> [url=https://steamcommunity.com/sharedfiles/filedetails/?id=<THIS_MOD_ID>]Nelim's Animals, Naturally[/url]

**Sarg Bjornson, on Alpha Animals** (223 characters):

> Borrowed a page from Animals Forage and gave the Crystalline Caracal the same dig-when-hungry trick,
> since nothing else covered it yet. Simple graphic, real mechanic — the recipe works. Thanks for the
> caracal xD
> [url=https://steamcommunity.com/sharedfiles/filedetails/?id=<THIS_MOD_ID>]Nelim's Animals, Naturally[/url]

**Oskar Potocki, on Vanilla Animals Expanded** (241 characters):

> Extended the same forage-when-hungry behaviour Animals Forage gives vanilla critters to the VAE
> animals it hadn't reached — no overlap, just filling the gaps your own spreadsheet already mapped
> out. Appreciate the sheer scale of it :)
> [url=https://steamcommunity.com/sharedfiles/filedetails/?id=<THIS_MOD_ID>]Nelim's Animals, Naturally[/url]

## Gallery captures (2026-10-02)

Folder `Art/gallery/` holds only the images to upload, numbered `0-`, `1-`, `2-`; `0-preview.png` is a byte copy of `Mod/About/Preview.png`. Captures come from `Tests/Pickle/Mod/Pickle/Features/07-galerie.feature` (pass `galerie`), raw pictures stay in the ignored `Tests/Pickle/Evidence/` and are cropped before they go to `Art/gallery/`.

**Zoom rule (owner, 2026-10-02): the subject fills at least 50 percent of the screen height or width.** Not stated in the shared `PUBLISHING.md`, so it is written here and in the feature header. The numbers of the framing steps (`I frame` sets zoom 9, then `I zoom in`) are only a starting point: judge the picture, not the number.

| Order | Image | Shows | State |
|---|---|---|---|
| 0 | `0-preview.png` | the Preview | done |
| 1 | size range | mouse to elephant side by side | scenario written, not played |
| 2 | horse health tab | menu capture, not staged (an animal has no Bio tab) | scenario written, not played |
| 3 | forage | a hungry grizzly beside berry bushes | scenario written, not played; digging is not asserted, read it on the picture |

### Staging of the gallery (owner's rule, 2026-10-02)

Every gallery image is a staged photograph, except menus (the Health tab, image 2, is a screenshot of what it is). Story for the series: **the naturalist's plate**. A field station in the meadow of the shared studio (`nelim-zen-meadow-studio`): same backdrop for the whole series, a standing lamp, plants and a shelf where they tell something. Image 1: the animals lined up by size, mouse to elephant, as on a field-guide plate. Image 3: a grizzly digging berries beside berry bushes. Decor is placed, photographed, removed, then the next image.

Steps this needs and the catalogue does not have (asked of Pickle Tools on 2026-10-02): an animal spawned on an exact cell or in a row, decor placed by defName and removed, an animal's food set, framing of a cell rectangle to a share of the screen. Until they exist, `07-galerie.feature` uses `close together` and the test colony, and its pictures are tests of the trip, not gallery material.
