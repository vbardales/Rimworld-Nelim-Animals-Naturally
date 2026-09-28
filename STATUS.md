---
mod: "Nelim's Animals, Naturally"
packageId: nelim.animalrebalance
repo: https://github.com/vbardales/Rimworld-Nelim-Animals-Naturally
visibility: public
detached: yes
stage: l10n
stage_meaning: "options→l10n needs FR/EN resources existing and verified, and every displayed text translatable and covered; the mod displays no text at all (XML-only patches), so localization/translation_en/translation_fr stay not_applicable"
licence: open
licence_at: "MIT for original rebalancing work; third-party definitions are not redistributed"
upstream_mod_remotes:
  - https://github.com/emipa606/XNDNocturnalAnimals
  - https://github.com/emipa606/DogsMate
  - https://github.com/emipa606/SomeLikeItRotten
  - https://github.com/emipa606/AnimalsForage
  - https://github.com/Vanilla-Expanded/VanillaExpandedFramework
  # Zoology has no GitHub link in its About.xml (checked 2026-09-28): N/A
dependencies: partial
showcase: partial
settings_audit: not_applicable
localization: not_applicable
translation_en: not_applicable
translation_fr: not_applicable
tested_on:
workshop:
remaining:
  - resolved 2026-09-28: RimWorld loads with the required Nocturnal Animals dependency, run f607/sans-facultatifs-r2, 10/10 passed, 0 failed
  - unverified: optional-mod combinations avec-vef (run 4031 pending, filter fixed)
  - blocked, needs Virginie: Some Like It Rotten (run 1899) and Zoology (run 6e7f) both stall RimWorld at the identical startup point alone, exit 3, no report, no error logged; only Dogs Mate loads cleanly (run 574d, 1/1 passed). 03-dogsmate.feature ran; 04-rotten.feature and 05-zoology.feature cannot run until this is fixed. Possible cause: a corrupted or incomplete Workshop download of these two specific mods on this machine; needs Steam-side verification, not something this session can check or fix
  - unverified: new game and existing-save behaviour (argued not applicable in TESTING.md, awaiting Virginie)
  - unverified: suspected defect, Hybridation.xml lists defs of absent mods in canCrossBreedWith (possible load errors)
  - resolved 2026-09-28: Forage.xml Meat_Rat guard works (AA_CrystallineCaracal patched in run e85c); Meat_Megaspider (Herisson) rechecked by a corrected scenario, rerun pending
  - resolved 2026-09-28: values the patches write, run fd90/valeurs, 11/11 applicable scenarios passed with PickleTools' DefFields companion (Horse baseBodySize 1.926, gestationPeriodDays 24.17, first game run of this companion)
  - pending: executed results for every conditional scenario (3 passes requested 2026-09-28), then read reports, before tested
  - pending: Doublons.xml and the other animal packs have no scenario that shows a patch firing
updated: 2026-09-28
---

# Nelim's Animals, Naturally — status

## Audit summary — 2026-09-22

This audit inspected the delivered `Mod/` tree without launching RimWorld.

- All 14 XML files in `Mod/` and `config/` parse successfully.
- The ten delivered patch files are XML-only. There is no assembly, source directory,
  `Languages/` directory, `Keyed` resource, `DefInjected` resource, `MainButtonDef`, or
  settings implementation in this checkout.
- The absence of a settings page and MainButtons shortcut is therefore justified:
  `settings_audit: not_applicable`. This mod has no useful user-facing setting to expose.
- The patches do not add player-facing labels, descriptions, gizmos, messages, or other
  localisable text. `localization`, `translation_en`, and `translation_fr` are therefore
  `not_applicable`. The About metadata and repository documentation are English, but are
  outside the in-game localization gate.
- `About/ModIcon.png` is 128 x 128 pixels and 22,876 bytes. `About/Preview.png` is
  896 x 504 pixels and 611,797 bytes, below the one-megabyte Workshop limit.
- `Rythme.xml` uses the Nocturnal Animals `DefModExtension`; the required dependency is
  declared in `About.xml`. Dogs Mate, Some Like It Rotten, and Zoology are load-after
  integrations. `Forage.xml` is guarded by `PatchOperationFindMod` for Vanilla Expanded
  Framework.

The static evidence does not establish that every XPath finds its target, that each
optional integration loads cleanly, or that the rebalanced animals behave correctly in game.
No game session, log review, save test, or English/French in-game display test has been run.

## Workflow position

The mod reached `horsMonoRepo` on 2026-09-26. The standalone repository is
`vbardales/Rimworld-Nelim-Animals-Naturally`; its remote was verified, and merge commit
`e5a23d6` was pushed to `main`. The old flattened distribution layout was removed in that
merge; the published payload is now solely `Mod/`.

The repository is now public. Virginie gave explicit approval on 2026-09-27, on the basis
that the mod contains only rebalancing (no redistributed third-party content). Before flipping
visibility, the full commit history (`git log --all -p`, 15 commits) and all historical
filenames were scanned for secrets, keys, and credentials: nothing was found beyond
documentation references to the CI publish procedure. Visibility was then switched via
`gh repo edit vbardales/Rimworld-Nelim-Animals-Naturally --visibility public` and confirmed
(`isPrivate: false`).

Before `preTest`, add targeted XML patch-target tests
and functional scenarios. In-game validation remains required for `tested`.

## Testing evidence — 2026-09-26

No `Tests/Pickle/`, `evidence/`, `Tests/Pickle/Evidence/`, or `.dds` file exists in this
checkout, and none is tracked by Git. `.gitignore` now excludes generated evidence and DDS
files. `TESTING.md` records the only evidence to retain for a tested revision: the newest
terminal `summary.json` and `junit.xml` for each scenario, plus review screenshots that
actually establish a visual claim. No deletion was necessary.

The absence of Pickle feature files means no `@wip` tag was found, but it does not satisfy
the test gate: the required conditional scenarios and manual-test checklist do not exist,
and no results are green. These are pending work, not observed defects.

## Upstream source review — 2026-09-26

The GitHub repository `vbardales/Rimworld-Nelim-Animals-Naturally` is not a fork. A GitHub
search for the former French title returned no repository. The project attribution identifies
the rebalancing work as Nelim's original work, and no upstream code repository was found to
use as a PR target. Recheck this only if a concrete original-mod identity or URL is found.

## Artwork review — 2026-09-26

`Mod/About/ModIcon.png` was inspected directly: it is a 128 x 128 PNG (22,876 bytes)
with a high-contrast animal-and-balance-scale motif. `Mod/About/Preview.png` was inspected
directly: it is an 896 x 504 PNG (611,797 bytes), below the Workshop limit, with distinct
dark, cream, and gold accents. Both delivered image files exist.

The preview contains the obsolete French heading “Reequilibrage realiste des animaux” and
French subtitle text, while the mod is now named “Nelim's Animals, Naturally” and its public
metadata is English. This is a confirmed visual defect for the `Preview générée → preOptions`
transition. No image was generated or modified during this audit.

## Artwork regeneration attempt — 2026-09-27 (blocked)

`Art/Preview-source.png`, `Art/Preview.ico`, and `Art/ModIcon.ico` already exist, but no
`Art/render-preview.cjs`, `preview-palette.json`, `preview-qa.json`, or `preview.html`
existed yet. Two sibling scripts were inspected
(`AncientBuildingsRenew/Art/render-preview.cjs`, `AlphaMythologyRenew/Art/`) to learn the
expected shape: a headless-Chromium (`playwright` + `sharp`) render of an HTML overlay onto
the source image, with a palette JSON for accent/ink colours and a QA JSON recording
contrast ratios and output size, gated at <900 KB and >=4.5:1 contrast.

Before adapting this pipeline for AnimalsNaturally, dependency availability was checked:

- `node --version`: v24.13.0, available.
- `sharp`: resolvable only from the global npm root (`npm root -g`), not from this repo or
  the monorepo root — would need `NODE_PATH` or a local install to use directly.
- `playwright`: **not found** anywhere reachable from this repo or the monorepo root. It
  exists only inside two unrelated sibling mods' own `node_modules`
  (`AdaptiveStorageNeolithicRenew/node_modules/playwright`,
  `AncientChineseBeastAndGeneExpandedRenew/node_modules/playwright`), and
  `AncientBuildingsRenew` itself — whose script was used as the template — currently has
  **no** `node_modules` of its own either, so its own render script is not runnable as-is
  right now.
- Chrome executable is present (`C:\Program Files\Google\Chrome\Application\chrome.exe`),
  which the sibling script needs (`CHROME_PATH`), but that alone does not satisfy the
  `playwright` Node dependency the script requires to drive it.

Per the audit brief's explicit instruction not to hand-roll a substitute image pipeline when
canvas/render dependencies are unavailable, **no image was regenerated**. `Mod/About/Preview.png`
is unchanged and still carries the stale French title. This remains a `defect`/`blocker` in
`remaining`, not a pass. Unblocking requires either installing `playwright` (and its browser
binaries) somewhere reachable from this repo, or a decision from Virginie on an alternative
tool.

## Settings/translation gate re-verification — 2026-09-27

Re-scanned `Mod/` for any settings implementation: no `.dll`, no `Languages/` directory, no
`MainButtonDef`, no settings XML. `Mod/About/About.xml` reconfirmed to carry no player-facing
label/description/gizmo text beyond the mod's own metadata. The 2026-09-22 conclusion stands
unchanged: `settings_audit: not_applicable`, `localization: not_applicable`,
`translation_en: not_applicable`, `translation_fr: not_applicable`. Re-dated to 2026-09-27; no
narrative changes needed since nothing in `Mod/` changed since the last audit.

## Evidence, .dds, and untracked-files pass — 2026-09-27

- `Tests/Pickle/Evidence/`, `evidence/`, and `Tests/Pickle/` still do not exist on disk in
  this checkout; nothing to prune. Checked the monorepo's `pickle-reports-archive/` for an
  archive referencing this mod (`AnimalsNaturally` or `nelim.animalrebalance`): none found.
- `git ls-files | grep -i dds`: no tracked `.dds` file. `.gitignore` already had `*.dds`
  since 2026-09-26. Nothing to untrack.
- Upstream check: one quick search pass found no upstream repository for the former French
  title or the mod's identity; the 2026-09-26 conclusion (original work, not a fork) stands.
- Untracked files resolved: `desktop.ini` (repo root and `Mod/`) added to `.gitignore`
  (files themselves left untouched on disk, per the local-icon convention in AGENTS.md).
  `Art/ModIcon.ico` and `Art/Preview.ico` are tracked in both `AncientBuildingsRenew` and
  `AlphaMythologyRenew`; the same convention was applied here and both files were `git add`ed.

## Publication-ID check — 2026-09-27

Searched the whole repository, including `config/`, for any file matching
`*publishid*`/`*publishedfileid*`: **none found**. No `About/PublishedFileId.txt` exists in
this checkout. Per the audit brief, `CHANGELOG.md`'s `Unreleased` section was left untouched
and no `0.1.0` heading was created — see the report to Virginie for the explicit question
this raises.

## Artwork regeneration — 2026-09-27

The `playwright`/`sharp` blocker recorded in the 2026-09-27 "Artwork regeneration attempt"
above is resolved: a local `package.json` (`{"dependencies":{"playwright":"^1.63.0",
"sharp":"^0.35.4"}}`) was added at the monorepo root and `npm install` succeeded, populating
`node_modules/` (now git-ignored). Chrome is present at
`C:/Program Files/Google/Chrome/Application/chrome.exe` and Playwright's browser cache was
already populated at `~/AppData/Local/ms-playwright`.

Built the preview pipeline for this mod, following the exact pattern of
`AncientBuildingsRenew/Art/` (`preview.html`, `preview-palette.json`, `render-preview.cjs`):
a local static file server, `chromium.launch` against the installed Chrome, a 896x504 /
`deviceScaleFactor: 1` screenshot, Segoe UI font-family assertions via CDP
(`CSS.getPlatformFontsForNode`), per-element contrast QA sampled from a background-only
capture, and `sharp` compression to `Mod/About/Preview.png`.

New files: `Art/preview-palette.json` (veil `#241C13`, inkPrimary `#F7EFDD`, inkSecondary
`#D8A85E`, accent `#B9762E`, badgeInk `#17120E`, sampled/complementary to the cream
`Preview-source.png` background), `Art/preview.html` (English title "Nelim's Animals," /
suffix "Naturally", tag "Biology-based animal rebalancing", a one-line description drawn from
`About.xml`'s body-size/lifespan/taming/hybridisation summary, and a `.version` badge read at
render time from `About.xml`'s `supportedVersions` — currently `1.6`), and
`Art/render-preview.cjs`.

Ran `node Art/render-preview.cjs` from the repository root. First pass failed the 4.5:1
contrast gate on `.tag` and `p` (4.29 and 4.32); fixed by strengthening the veil gradient
(radius 900x680 at .94/.90 opacity → 980x760 at .97/.95) and darkening `inkSecondary`
(`#E0B978` → `#D8A85E`). Second pass passed cleanly with no threshold changes:

- `Mod/About/Preview.png`: 896 x 504, **519,847 bytes** (well under the ~900 KB gate and the
  1 MB Workshop limit; previous file was 611,797 bytes).
- QA (`Art/preview-qa.json`), `version: "1.6"`, all Segoe UI / Segoe UI Semibold / Segoe UI
  Bold as expected, minContrast per element: `h1` 12.84, `.suffix` 6.96, `.tag` 6.78, `p`
  9.89, `.version` 5.04 — every element clears the 4.5:1 gate.
- `Art/preview-268.png` (61,311 bytes) and `Art/preview-background.png` (500,246 bytes)
  written alongside.

The former French title/copy defect recorded in the 2026-09-26 "Artwork review" is resolved:
`Mod/About/Preview.png` now shows the English title, tag, and description. `stage` advances
from `Preview générée` to `preOptions` per `AUDIT.md`'s stage list
(`... → Preview générée → preOptions → options → ...`); `settings_audit` was already
re-verified `not_applicable` on 2026-09-27 and needs no further check before this transition.


## Pickle suite written and requested — 2026-09-28

`Tests/Pickle/` created (commit df0bb78): 5 features, 22 scenarios, no @wip, only Pickle-built-in steps. Families: baseline
with Nocturnal Animals only (01), Forage/VEF (02), loadAfter Dogs Mate (03), Some Like It Rotten (04), Zoology (05). Three passes,
maps and filters in `Tests/Pickle/README.md`. Values are not readable with Pickle (ambiguous names), so scenarios assert load,
attribution and silence; gaps and two suspected defects in `TESTING.md`.

Runs: **none played.** Three requests filed with the dispatcher (queue held 48 tickets): 20260928-120658-213-b488 (sans-facultatifs),
20260928-120658-891-e85c (avec-vef), 20260928-120659-683-72fd (avec-loadafter), owner local_4f4ac5d9-e73c-413b-aa6e-e62db376eaa8, evidence to
`Tests/Pickle/Evidence/<pass>`. Keep `Mod/` unchanged until RUN_DONE. No report exists, so nothing is passed.

Stage stays `preOptions`: no run evidence, and the vocabulary gap and suspected defects are unresolved.
