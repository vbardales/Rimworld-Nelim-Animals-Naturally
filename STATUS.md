---
mod: "Nelim's Animals, Naturally"
packageId: nelim.animalrebalance
repo: https://github.com/vbardales/Rimworld-Nelim-Animals-Naturally
visibility: public
detached: yes
stage: Preview générée
licence: open
licence_at: "MIT for original rebalancing work; third-party definitions are not redistributed"
dependencies: partial
showcase: partial
settings_audit: not_applicable
localization: not_applicable
translation_en: not_applicable
translation_fr: not_applicable
tested_on:
workshop:
remaining:
  - unverified: RimWorld load with the required Nocturnal Animals dependency
  - unverified: optional-mod combinations, patch targets, and game logs
  - unverified: new game and existing-save behaviour
  - defect: Preview.png still displays the former French title and French copy
  - pending: test plan and automated/XML patch-target tests before preTest
  - pending: non-WIP scenarios for every applicable conditional patch family
  - pending: executed results for every conditional scenario and a completed manual-test checklist before tested
  - blocker: Preview.png regeneration requires Node "playwright" (Chromium automation), not
    installed anywhere in this checkout, the monorepo root, or global npm; only "sharp" is
    globally available. Not fixed by this pass; see "Artwork regeneration attempt" below.
  - pending: decision from Virginie on the 0.1.0/publishIdFile question (no publishIdFile
    exists anywhere in this checkout; see "Publication-ID check" below)
updated: 2026-09-27
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
