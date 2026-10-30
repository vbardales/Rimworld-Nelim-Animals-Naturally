---
mod: "Nelim's Animals, Naturally"
packageId: nelim.animalsnaturally
repo: https://github.com/vbardales/Rimworld-Nelim-Animals-Naturally
visibility: public
detached: yes
workflow_stage: shootGallery[1.0.0]
stage_meaning: "stage holds the 6-code field; workflow_stage carries the exact 12-state chain position, same value from preTest on. l10n→preTest crossed 2026-09-29 (see git history for detail). preTest→done is a static gate (AUDIT.md): automated + XML tests rerun (not read from an old report), Pickle suites written or their absence justified in writing. No in-game run is required for this gate (AUDIT.md's explicit 2026-09-21 clarification); that belongs to done→tested. Crossed 2026-09-30: Tests/Test-Xml.ps1 rejoué, vert (10 patch files, About.xml contract, fixtures, absent-mod safety); 5 Pickle feature files exist under Tests/Pickle/, coverage documented in TESTING.md."
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
tested_on: RimWorld 1.6 (WSL headless Pickle), Mod/ patches unchanged since e656137; green on 313d491..88b3028: 01-baseline sans-facultatifs-r2, 03 dogsmate, 05 zoology-slow2, 04 rotten-slow2, 06 valeurs-r2 (2/2), 02 avec-vef-r7 (7/7)
workshop: 3811381865 (private prepublication 0.1.0, 2026-10-01; item not public)
remaining:
  - state 2026-10-30 (sleep): owner decisions, hair of Nelim is the canon Roo_HD_Hair_Highpony in 07-galerie scenarios 1, 3, 4 (map gained rooboid.hdhair.continued 3559870636 and VanillaExpanded.VHE 1888705256; galerie-14 72fd may have been staged before this commit); the "Nelim" name label under her is accepted (no NPT step asked); replay-audit 2026-10-30 left workflow_stage unchanged, first open sub-step 9.a (shot 3 candidate Art/Gallery/3-candidate-cat-asleep.png refused on face blob and old hair, shots 1 and 4 to refile, rate-gallery plan mean 4.5). Pending tickets: galerie-14 72fd, cells d340, catalogue-1 4048. Pending answers: Audit via TM (opinion on catalogue image weight, Art/Catalogue request cancelled). Preview regeneration deferred to mountPreview (TM agreed)
  - open 2026-10-30 (owner order): catalogue scenarios. Front, back and profile capture of every animal of every mod (owner, 2026-10-30: "tous les animaux"), plus a registry mod to animal, then harmonise across mods. Whole corpus is the scope, thousands of animals, so batch by mod, 5 scenarios per ticket at most. Place fixed by the owner 2026-10-30: Docs/catalogues/animals.md (registry) and Docs/catalogues/img/<mod>/<defName>-{face,dos,profil}.jpg (images); Audit asked via TM only for an opinion on weight (thousands of images, public repo). Steps `"X" faces South`, `faces North` and `faces West` exist, so the three views may need no new step; ask NPT via TM only if a neutral backdrop step is missing. NPT steps compiled (PickleTools 8bde807: floor set to terrain, animal kinds listed, stands at facing). Probe written (08-catalogue.feature, 080af30: kinds listed + one horse front/back/side on Concrete), ticket `20261030-141246-930-4048` (catalogue-1, wsl-deps.galerie.map) filed 2026-10-30, waiting. On RUN_DONE: summary.json, then the 3 horse captures (does the named spawn obey stands-at-facing, does Concrete show and contrast, does root size 6 read at 268 px), and the [animal-kind] listing for the registry.  - resolved 2026-10-29 (8.m, resume): git diff f2117d21 HEAD -- Mod read: ATTRIBUTION.md prose only (sections, third-party targets listed, Claude and Codex named as tooling, no dependency claim), Preview.png derived render (625878 to 619880 bytes). No finding, code_review_sha moved to 7f7d3ef. Gallery work (9.a, shots 1 and 4 to redo, shot 3 candidate) resumes at shootGallery
  - resolved 2026-09-28: RimWorld loads with the required Nocturnal Animals dependency, run f607/sans-facultatifs-r2, 10/10 passed, 0 failed
  - resolved 2026-09-29: optional-mod combination avec-vef, run avec-vef-r5, 6/7 passed; the 1 failure was a test-authoring bug (see line below), rerun pending on the corrected scenario
  - resolved 2026-09-29: Zoology's "stall" was slow startup under the headless/Xvfb launcher, not a hang: run zoology-slow2 with -StallMinutes 20 -RunTimeoutMinutes 25 passed 3/3. Some Like It Rotten shared the identical signature (run 1899, exit 3, no report; only Dogs Mate loaded cleanly at default timeouts, run 574d 1/1); resubmitted with the same extended timeout as run rotten-slow, result pending. Download integrity was ruled out 2026-09-29: `diff -rq` between the Windows Workshop folder and a fresh steamcmd download is empty for both, byte-identical.
  - resolved 2026-10-01: new game and existing-save behaviour declared not applicable in TESTING.md, accepted by Virginie in chat (first such waiver in the monorepo, no precedent; XML-only, nothing saved, values rebuilt from the def at each load)
  - resolved 2026-09-28: suspected defect, Hybridation.xml lists defs of absent mods in canCrossBreedWith, refuted by run f607/sans-facultatifs-r2 ("the load logs no error" passed in the bare pass, which carries the absent-mod entries)
  - resolved 2026-09-29: Forage.xml Meat_Rat guard works (AA_CrystallineCaracal patched in run e85c). Meat_Megaspider guard: scenario asserted ACPHedgehog, but run avec-vef-r5 showed that def does not exist in this pass (its owning mod, Animal Collab Project, is not staged; only AEXP_Hedgehog/AEXP_Pangolin are). Scenario switched to AEXP_Pangolin, a Meat_Megaspider-guarded animal from a pack this pass does stage; rerun pending
  - resolved 2026-09-28: values the patches write, run fd90/valeurs, 11/11 applicable scenarios passed with PickleTools' DefFields companion (Horse baseBodySize 1.926, gestationPeriodDays 24.17, first game run of this companion)
  - resolved 2026-10-02: 04-rotten played green (rotten-slow2, exitReason passed, 1/1) with -StallMinutes 20 -RunTimeoutMinutes 25
  - resolved 2026-10-10: ticket 8ee7 (valeurs-r2, 06-valeurs) 2 passed 0 failed, exitReason passed, setName valeurs; ticket 3b7a (avec-vef-r7, 02-forage-vef) 7 passed 0 failed, exitReason passed, setName avec-vef (VAERoy_Pheasant patched by this mod); both exit 0, 1 attempt, scenarios played = scenarios in the feature (2 and 7). The RUN_DONE message was lost, found by reading results/<id>.json. 07-galerie remains for shootGallery
  - resolved 2026-10-01: Preview regenerated by Virginie (commit 268fcf3, dark panel layout, 610 KB), inspected: title and text legible; copied identically to Art/gallery/0-preview.png
  - resolved 2026-10-02: THANKS credits the maintainer (Mlie, 2269731409) and the original author (XeoNovaDan, 2004368312), per the WORKSHOP_COMMENTS.md register
  - audit 2026-10-13 (8.a to 8.n re-read at shootGallery, session): 8.a Mod/ patches unchanged since e656137; 8.c 01 to 06 green (see tested_on, docs/runs/), 07 played 3/3 (galerie-5, 4b5e); 8.d captures opened: 1 scale and 3 pheasant kept as candidates, 2 refused (Health tab shows Dev tool button, resource list); 8.e no @wip scenario; 8.g S1 to S11 covered offline or in game (S12 not testable, TEST_SCENARIOS.md); 8.k none left; 8.l evidence trimmed (galerie-4 no-report and galerie-5 reports deleted); 8.m the only Mod/ change since 88b3028 is the derived Mod/About/Preview.png (626113 to 625878 bytes, render of 2026-10-12), reviewed: image only, code_review_sha moved to HEAD. TEST_SCENARIOS.md stale 'not played' lines corrected
  - open 2026-10-17: Virginie refused the three old candidates (galerie-5/6), deleted. galerie-7 (1945) read: 1 scale (green tint on left ground), 3 pheasant (torch hides tail, no-power icon, small) and 2 card (HUD left around window) all refused or redone. Scenarios retuned (84741e3), ticket galerie-8 (aebd) ran 2026-10-17 exit 1, no report: staging failed (rm 'Directory not empty' on Mods/2871933948, same path as DrumBathHygiene f485; runs are serial, not a collision; host/launcher cause, for NPT), infra not test; refiled as galerie-9 (620b, exit 3, no report: startup stall), galerie-10 (694c) abandoned, 2026-10-20 filed galerie-11 (6904: probe + workshop 1 + workshop 2, -StallMinutes 20 -RunTimeoutMinutes 25), waiting. Redesign in progress (owner: iterate until fully satisfied, Audit rule 2026-10-18; shotlist self-grade 2/5): image 1 concept kept (tint to fix on reading); image 2 horse Stats card kept but story weak (link to image 1 in Steam text); image 3 pheasant dropped for a hungry Bear_Grizzly (Forage.xml RawBerries x10), unproven that the dig is visible: a `probe` scenario (3 frames 0/300/1200 ticks) sits in 07-galerie.feature and is played by 620b; read probe-0, probe-300, probe-1200 first, then rewrite scenario 3 (delete probe), fallback place RawBerries with StageDecor. PUBLICATION.md "Staging of the gallery" section is stale, rewrite after the shots are fixed. Look in GALLERY-PROPS.md and ColonistRace/docs/CATALOGUE-*.md before adding props. Staging failure cause (aebd): copy_mod rm -rf on Mods/2871933948 fails "Directory not empty" and the $(copy_steam) subshell swallows set -e (stage-pickle-wsl.sh lines 123-134, 353-416), NPT/launcher to fix; if 620b dies the same way, tell NPT via TM. Subtitle lines for 1 and 3 written in PUBLICATION.md. NPT unreachable (green tint and no-power icon not relayed): if they come back, tell Virginie. Then reindex, Art/Gallery-clean, Add-Subtitle, echo review and 0- copy at mountPreview
  - resolved 2026-10-10: Virginie replaced Art/ModIcon-source.png (1219x1290 RGBA, was 102x108). Added modIconSource to Preview.config.json and ran `node ../scripts/Render-Preview.cjs`: Mod/About/ModIcon.png 128x128 RGBA 25806 bytes, Mod/About/Preview.png 896x504 626113 bytes, Art/gallery/0-preview.png byte copy (cmp), both ICO regenerated. Uncommitted .ico changes in the tree were overwritten by this render. Icon read at 32 px (head, scale and animals distinguishable); Virginie confirmed the 32 px legibility in chat on 2026-10-10 (2.c closed)
  - unverified 2026-10-10 (10.d, mountPreview): pixel-minimum contrast of ink over the rendered background (Art/.render/Preview-background-qa.png) is 3.44 under the title and 3.50 under the summary, mostly where the echo line art crosses the text block; palette and layout unchanged by this render, shared renderer no longer records contrast. Recheck at mountPreview
  - resolved 2026-10-10 (7.a/7.f): TEST_SCENARIOS.md written (12 scenarios S1-S12), tested sha 7b3f83a recorded there with the Test-Xml rerun
  - defect 2026-10-10: About.xml says "a macaw lives for 55 years" but Lifespan.xml has no Macaw entry (parrot-family lifespans written: BB_Parrot, BB_ParrotB, TYR_Parrot_Caica, BB_Cockatoo, 52.1 to 56.6). Public text to correct at writeDocs; see TEST_SCENARIOS.md "Figures checked"
  - resolved 2026-10-10: S2 (Chicken 7.2, Cow 30.6, Cow gestation 25.35), S3 (AA_BoulderMit 0.2), S4 (AA_IronhuskBeetle roamMtbDays removed) and S5 (no 99999 in any patch file) now asserted by Tests/Test-Xml.ps1 (PASS, negative check done); 06-valeurs gains a second scenario (Chicken, Cow, Warg values), not played, needs a ticket on the valeurs pass
  - resolved 2026-10-10: TicketManager registered owner local_eebd9331-d00c-47a9-a591-c39da17310c8 (replaces local_4f4ac5d9). Old tickets: 994e (avec-vef-r7) and 282f (galerie) have no owner, no status, never played; 795f (galerie-1) exit 1, already relayed. Nothing queued. 02-forage-vef and 07-galerie remain unplayed
  - resolved 2026-10-10: protocols read in full (AGENTS, AUDIT, PICKLE, PUBLISHING, TRANSLATIONS, STYLE_RIMWORLD, MOD_SETTINGS, SEARCHING, WORKSHOP_COMMENTS "Writing a comment", WELCOME); protocols_read_sha 8dc7759 written by Mark-ProtocolsRead.ps1
  - unverified: 0.1.0 prepublication content: whether the uploaded Preview.png was the committed or the uncommitted one is not recorded
  - resolved 2026-09-29: Doublons.xml removal logic proven offline (Tests/Test-Xml.ps1, SCWelshCorgi/TemperateForest synthetic fixture: wildBiomes and wildAnimals entry both removed); dozens of other packs still unstaged in Tests/Pickle/ (see TESTING.md "What is not covered")
  - resolved 2026-09-29: Preview.png carries the cut-out ModIcon, bottom-right corner, -15deg (owner's rule, PUBLISHING.md). Migrated same day to the shared `../scripts/Render-Preview.cjs` + `../scripts/Make-PreviewBadge.ps1` pipeline (own `Art/render-preview.cjs`/`cutout-icon.cjs` deleted; `Art/preview-copy.json` now holds the mod-specific text, `Art/verify-preview.py` the contrast/size QA the shared script no longer does itself). Palette retuned for the new layout's lighter veil: inkSecondary `#D8A85E`->`#E0B97E`, inkPrimary `#F7EFDD`->`#FBF6EC`. Verified: title 10.23, suffix 5.99, tag 4.88, p 4.59, version 5.04, 535632 bytes. Art/gallery/0-preview.png recopied by hand (the shared script does not do this itself; naming settled 2026-09-29, single digit lowercase, was Art/steam/00-Preview.png hours earlier). No further Gallery images exist yet, no @review/@film Pickle scenario to source them from.
code_review_sha: 7f7d3efb35e4a3e0c54bc2bfddca3b0c644ad01a
updated: 2026-10-29
protocols_read_sha: 96fd9a43a0beb0d12889a50e05135b8d86ded0e3
---
# Nelim's Animals, Naturally — status

## Audit summary — 2026-09-22

Audit inspected delivered `Mod/` tree. RimWorld not launched.

- All 14 XML files in `Mod/` and `config/` parse OK.
- Ten delivered patch files XML-only. No assembly, source dir, `Languages/` dir, `Keyed` resource, `DefInjected` resource, `MainButtonDef`, or settings implementation in checkout.
- No settings page, no MainButtons shortcut = justified:
  `settings_audit: not_applicable`. Mod has no useful user-facing setting to expose.
- Patches add no player-facing labels, descriptions, gizmos, messages, or other localisable text. `localization`, `translation_en`, `translation_fr` therefore
  `not_applicable`. About metadata and repo docs English, but outside in-game localization gate.
- `About/ModIcon.png` 128 x 128 px, 22,876 bytes. `About/Preview.png`
  896 x 504 px, 611,797 bytes, below one-megabyte Workshop limit.
- `Rythme.xml` uses Nocturnal Animals `DefModExtension`; required dependency declared in `About.xml`. Dogs Mate, Some Like It Rotten, Zoology = load-after
  integrations. `Forage.xml` guarded by `PatchOperationFindMod` for Vanilla Expanded
  Framework.

Static evidence does not prove every XPath finds target, each
optional integration loads clean, or rebalanced animals behave right in game.
No game session, log review, save test, or English/French in-game display test run.

## Workflow position

Mod reached `horsMonoRepo` 2026-09-26. Standalone repo
`vbardales/Rimworld-Nelim-Animals-Naturally`; remote verified, merge commit
`e5a23d6` pushed to `main`. Old flattened distribution layout removed in that
merge; published payload now solely `Mod/`.

Repo now public. Virginie gave explicit approval 2026-09-27, because
mod contains only rebalancing (no redistributed third-party content). Before flipping
visibility, full commit history (`git log --all -p`, 15 commits) and all historical
filenames scanned for secrets, keys, credentials: nothing found beyond
documentation references to CI publish procedure. Visibility switched via
`gh repo edit vbardales/Rimworld-Nelim-Animals-Naturally --visibility public` and confirmed
(`isPrivate: false`).

Before `preTest`, add targeted XML patch-target tests
and functional scenarios. In-game validation still required for `tested`.

## Testing evidence — 2026-09-26

No `Tests/Pickle/`, `evidence/`, `Tests/Pickle/Evidence/`, or `.dds` file in this
checkout, none tracked by Git. `.gitignore` now excludes generated evidence and DDS
files. `TESTING.md` records only evidence to keep for tested revision: newest
terminal `summary.json` and `junit.xml` per scenario, plus review screenshots that
actually establish a visual claim. No deletion needed.

No Pickle feature files = no `@wip` tag found, but test gate not satisfied:
required conditional scenarios and manual-test checklist do not exist,
no results green. Pending work, not observed defects.

## Upstream source review — 2026-09-26

GitHub repo `vbardales/Rimworld-Nelim-Animals-Naturally` not a fork. GitHub
search for former French title returned no repo. Project attribution identifies
rebalancing as Nelim's original work, no upstream code repo found
as PR target. Recheck only if concrete original-mod identity or URL found.

## Artwork review — 2026-09-26

`Mod/About/ModIcon.png` inspected directly: 128 x 128 PNG (22,876 bytes)
with high-contrast animal-and-balance-scale motif. `Mod/About/Preview.png` inspected
directly: 896 x 504 PNG (611,797 bytes), below Workshop limit, with distinct
dark, cream, gold accents. Both image files exist.

Preview contains obsolete French heading “Reequilibrage realiste des animaux” and
French subtitle text, while mod now named “Nelim's Animals, Naturally” and public
metadata English. Confirmed visual defect for `Preview générée → preOptions`
transition. No image generated or modified in this audit.

## Artwork regeneration attempt — 2026-09-27 (blocked)

`Art/Preview-source.png`, `Art/Preview.ico`, `Art/ModIcon.ico` already exist, but no
`Art/render-preview.cjs`, `preview-palette.json`, `preview-qa.json`, or `preview.html`
existed yet. Two sibling scripts inspected
(`AncientBuildingsRenew/Art/render-preview.cjs`, `AlphaMythologyRenew/Art/`) to learn expected shape: headless-Chromium (`playwright` + `sharp`) render of HTML overlay onto
source image, with palette JSON for accent/ink colours and QA JSON recording
contrast ratios and output size, gated at <900 KB and >=4.5:1 contrast.

Before adapting pipeline for AnimalsNaturally, dependency availability checked:

- `node --version`: v24.13.0, available.
- `sharp`: resolvable only from global npm root (`npm root -g`), not from this repo or
  monorepo root — needs `NODE_PATH` or local install to use directly.
- `playwright`: **not found** anywhere reachable from this repo or monorepo root. Exists
  only inside two unrelated sibling mods' own `node_modules`
  (`AdaptiveStorageNeolithicRenew/node_modules/playwright`,
  `AncientChineseBeastAndGeneExpandedRenew/node_modules/playwright`), and
  `AncientBuildingsRenew` itself — whose script was template — currently has
  **no** `node_modules` of its own either, so its render script not runnable as-is
  now.
- Chrome executable present (`C:\Program Files\Google\Chrome\Application\chrome.exe`),
  which sibling script needs (`CHROME_PATH`), but that alone does not satisfy
  `playwright` Node dependency script requires to drive it.

Per audit brief's explicit instruction not to hand-roll substitute image pipeline when
canvas/render dependencies unavailable, **no image regenerated**. `Mod/About/Preview.png`
unchanged, still carries stale French title. Remains `defect`/`blocker` in
`remaining`, not a pass. Unblocking needs either installing `playwright` (and browser
binaries) somewhere reachable from this repo, or decision from Virginie on alternative
tool.

## Settings/translation gate re-verification — 2026-09-27

Re-scanned `Mod/` for settings implementation: no `.dll`, no `Languages/` directory, no
`MainButtonDef`, no settings XML. `Mod/About/About.xml` reconfirmed no player-facing
label/description/gizmo text beyond mod's own metadata. 2026-09-22 conclusion stands:
`settings_audit: not_applicable`, `localization: not_applicable`,
`translation_en: not_applicable`, `translation_fr: not_applicable`. Re-dated 2026-09-27; no
narrative changes needed, nothing in `Mod/` changed since last audit.

## Settings/translation gate re-verification — 2026-09-30

Rechecked after French-translation sweep found translations only by folder name and asked to
recheck this mod for anything missed. `find` for `Languages`/`Keyed`/`DefInjected` anywhere under
checkout found one hit: `Tests/Pickle/Mod/Languages/README.md`, loose file with no language
subfolder (`LanguageDatabase` only enumerates directories under `Languages/`, so loose file
never parsed) that exists solely to stop RimWorld logging "did not load any content" for Pickle
companion mod; carries no key, not part of shipped `Mod/`. No other `Languages/`
folder at any depth (Mod/, version folders, LoadFolders, integrations).
Every field name across all 10 patch files in `Mod/Patches/` enumerated (`baseBodySize`,
`bodyClock`, `canCrossBreedWith`, `comps`, `customAmountToDig`, `customThingToDig`,
`eggCountRange`, `eggFertilizationCountMax`, `eggLayIntervalDays`, `gestationPeriodDays`,
`lifeExpectancy`, `litterSizeCurve`, `manhunterOnDamageChance`, `mateMtbHours`, `maxPreyBodySize`,
`milkAmount`, `milkIntervalDays`, `minAge`, `onlyWhenTamed`, `points`, `shearIntervalDays`,
`ticksToDig`, `woolAmount`, plus patch-structural tags `li`/`mods`/`name`/`operations`/`Patch`/
`success`/`value`/`xpath`): none is `label`, `description`, or other translatable string field.
No `label`/`description` substring in any patch file. No C# strings, `Translate()`
calls, Messages/Letters/Alerts/gizmo labels possible: `Mod/` has no `Source/`, no `.dll`, no
`Defs/` folder (only `About/` and `Patches/`), so no `Mod` subclass and no settings UI can exist —
`settings_audit: not_applicable` not a choice not to expose one, structurally impossible
in this checkout. `About.xml` reconfirmed English-only metadata, outside in-game gate.
Verdict unchanged from 2026-09-22/09-27: `settings_audit`, `localization`, `translation_en`,
`translation_fr` all stay `not_applicable`. Re-dated 2026-09-30.

## Evidence, .dds, and untracked-files pass — 2026-09-27

- `Tests/Pickle/Evidence/`, `evidence/`, `Tests/Pickle/` still absent on disk in
  checkout; nothing to prune. Checked monorepo's `pickle-reports-archive/` for archive referencing this mod (`AnimalsNaturally` or `nelim.animalsnaturally`): none found.
- `git ls-files | grep -i dds`: no tracked `.dds` file. `.gitignore` already had `*.dds`
  since 2026-09-26. Nothing to untrack.
- Upstream check: one quick search pass found no upstream repo for former French
  title or mod's identity; 2026-09-26 conclusion (original work, not a fork) stands.
- Untracked files resolved: `desktop.ini` (repo root and `Mod/`) added to `.gitignore`
  (files left untouched on disk, per local-icon convention in AGENTS.md).
  `Art/ModIcon.ico` and `Art/Preview.ico` tracked in both `AncientBuildingsRenew` and
  `AlphaMythologyRenew`; same convention applied here, both files `git add`ed.

## Publication-ID check — 2026-09-27

Searched whole repo, including `config/`, for file matching
`*publishid*`/`*publishedfileid*`: **none found**. No `About/PublishedFileId.txt` in
checkout. Per audit brief, `CHANGELOG.md`'s `Unreleased` section left untouched
and no `0.1.0` heading created — see report to Virginie for explicit question
this raises.

## Artwork regeneration — 2026-09-27

`playwright`/`sharp` blocker from 2026-09-27 "Artwork regeneration attempt"
above resolved: local `package.json` (`{"dependencies":{"playwright":"^1.63.0",
"sharp":"^0.35.4"}}`) added at monorepo root, `npm install` succeeded, populating
`node_modules/` (now git-ignored). Chrome present at
`C:/Program Files/Google/Chrome/Application/chrome.exe`, Playwright's browser cache
already populated at `~/AppData/Local/ms-playwright`.

Built preview pipeline for this mod, following exact pattern of
`AncientBuildingsRenew/Art/` (`preview.html`, `preview-palette.json`, `render-preview.cjs`):
local static file server, `chromium.launch` against installed Chrome, 896x504 /
`deviceScaleFactor: 1` screenshot, Segoe UI font-family assertions via CDP
(`CSS.getPlatformFontsForNode`), per-element contrast QA sampled from background-only
capture, `sharp` compression to `Mod/About/Preview.png`.

New files: `Art/preview-palette.json` (veil `#241C13`, inkPrimary `#F7EFDD`, inkSecondary
`#D8A85E`, accent `#B9762E`, badgeInk `#17120E`, sampled/complementary to cream
`Preview-source.png` background), `Art/preview.html` (English title "Nelim's Animals," /
suffix "Naturally", tag "Biology-based animal rebalancing", one-line description drawn from
`About.xml`'s body-size/lifespan/taming/hybridisation summary, and `.version` badge read at
render time from `About.xml`'s `supportedVersions` — currently `1.6`), and
`Art/render-preview.cjs`.

Ran `node Art/render-preview.cjs` from repo root. First pass failed 4.5:1
contrast gate on `.tag` and `p` (4.29 and 4.32); fixed by strengthening veil gradient
(radius 900x680 at .94/.90 opacity → 980x760 at .97/.95) and darkening `inkSecondary`
(`#E0B978` → `#D8A85E`). Second pass passed clean, no threshold changes:

- `Mod/About/Preview.png`: 896 x 504, **519,847 bytes** (well under ~900 KB gate and
  1 MB Workshop limit; previous file 611,797 bytes).
- QA (`Art/preview-qa.json`), `version: "1.6"`, all Segoe UI / Segoe UI Semibold / Segoe UI
  Bold as expected, minContrast per element: `h1` 12.84, `.suffix` 6.96, `.tag` 6.78, `p`
  9.89, `.version` 5.04 — every element clears 4.5:1 gate.
- `Art/preview-268.png` (61,311 bytes) and `Art/preview-background.png` (500,246 bytes)
  written alongside.

Former French title/copy defect from 2026-09-26 "Artwork review" resolved:
`Mod/About/Preview.png` now shows English title, tag, description. `stage` advances
from `Preview générée` to `preOptions` per `AUDIT.md`'s stage list
(`... → Preview générée → preOptions → options → ...`); `settings_audit` already
re-verified `not_applicable` 2026-09-27, needs no further check before transition.


## Pickle suite written and requested — 2026-09-28

`Tests/Pickle/` created (commit df0bb78): 5 features, 22 scenarios, no @wip, only Pickle-built-in steps. Families: baseline
with Nocturnal Animals only (01), Forage/VEF (02), loadAfter Dogs Mate (03), Some Like It Rotten (04), Zoology (05). Three passes,
maps and filters in `Tests/Pickle/README.md`. Values not readable with Pickle (ambiguous names), so scenarios assert load,
attribution, silence; gaps and two suspected defects in `TESTING.md`.

Runs: **none played.** Three requests filed with dispatcher (queue held 48 tickets): 20260928-120658-213-b488 (sans-facultatifs),
20260928-120658-891-e85c (avec-vef), 20260928-120659-683-72fd (avec-loadafter), owner local_4f4ac5d9-e73c-413b-aa6e-e62db376eaa8, evidence to
`Tests/Pickle/Evidence/<pass>`. Keep `Mod/` unchanged until RUN_DONE. No report exists, so nothing passed.

Stage stays `preOptions`: no run evidence, vocabulary gap and suspected defects unresolved.

## Audit — 2026-10-01 (revision 269a408 + e656137, Art/Preview files modified in the working tree)

Result: `stage: done`, `workflow_stage: done`, unchanged. Session title `animalsnaturally / done`.

- Prepublication: `Mod/About/PublishedFileId.txt` appeared (id 3811381865), committed as `e656137` ("Add published Workshop file ID for 0.1.0"); `CHANGELOG.md` opens with `## [0.1.0]` above `Unreleased`. This = act of prepublication, not `prepublished` state.
- `preTest -> done` rechecked: `pwsh.exe -File Tests/Test-Xml.ps1` PASS (10 patch files, About.xml contract, fixtures, absent-mod safety). Under Windows PowerShell 5.1 script fails 14 assertions: needs `pwsh` (7+), as TESTING.md already says.
- Git: no `.dds` tracked (`*.dds` ignored since 2026-09-26); no evidence tracked; `Tests/Pickle/Evidence/` ignored.
- Evidence trimmed on disk: kept `summary.json`, `junit.xml`, `summary.md`, `evidence-complete.txt` of sans-facultatifs-r2, avec-vef-r5, dogsmate, valeurs, zoology-slow2; kept `rotten/` (stall log) until rotten-slow reports; deleted `report.html`, `messages.ndjson`, `Player.log`, screenshots, no-report folders avec-loadafter and zoology, three `pickle-reports-archive/stalled-AnimalsNaturally-*` archives. Nothing `STATUS.md` cites removed.
- Upstream: `upstream_mod_remotes` already lists source repos (emipa606/*, Vanilla Expanded Framework). Mod = original rebalancing work, not fork, so no code to base PRs on; PRs go to those repos only if concrete fix to one found.
- Not done by audit: no new test run played. Two requests filed (see `remaining`). `tested` also needs: no `@wip` (none exist), every conditional scenario run (02 and 04 outstanding), no manual test left to validate (existing-save / new-game argued not applicable in TESTING.md, awaiting Virginie's acceptance).
- Reserve for `prepublished`, not blocker now: About.xml description lacks `IF I GO QUIET`, specific `THANKS`; `AI-GENERATED` line names OpenAI Codex only; `PUBLICATION.md` needs capture order and adult-content answers; Gallery has only `0-preview.png`.


## Preview source migration — 2026-10-02

Copy, typography, layout, palette consolidated in `Art/Preview.config.json`. Canonical inputs: `Art/Preview-source.png`, `Art/echo-concept.png` (renamed from `echo.png` 2026-10-12) and `Art/ModIcon-source.png`; shared renderer writes temporary diagnostics under ignored `Art/.render/`. Existing distributed Preview, gallery, ICO outputs preserved because present and coherent; no render run for migration. Superseded JSON files and generated QA intermediates removed. Nothing published.

## Audit — 2026-10-10 (revision 7b3f83a; working tree: Art/ModIcon.ico and Art/Preview.ico modified, Art/ModIcon-signature-candidate.png untracked, none mine)

Result: `done` (old vocabulary, `playTests`) -> `makeSources`. Version targeted: 1.0.0. Session title `animalsnaturally / makeSources`. `stage` field removed (retired 2026-10-09).

- First failing transition, `makeSources -> code` (2.b, 2.c): shipped icon stale, no alpha channel, source 102 x 108 (see `remaining`). Audit does not touch source, candidate, or ICO files. Not a generation task for a session: Virginie decides.
- Later transitions, retained independently of that block:
  - `declareDependencies` (4), verified 2026-10-10 at 7b3f83a: hard dependency Nocturnal Animals (`Mlie.XNDNocturnalAnimals`, Workshop 2269731409, declared with steamWorkshopUrl; Rythme.xml guarded by PatchOperationFindMod). `loadAfter`: Dogs Mate, Nocturnal Animals, Some Like It Rotten, Zoology (ordering only, no XPath targets the three optional ones). Forage.xml guarded by PatchOperationFindMod on Vanilla Expanded Framework. No `MayRequire` on any Operation, no `incompatibleWith`, no DLC branch, no LoadFolders, `supportedVersions` 1.6. ANIMALS.md does not apply (mod adds no animal).
  - `auditSettings` and `localize`: unchanged, `not_applicable` (no Source/, no DLL, no Languages/, no text field patched).
  - `writeTests` (7): `pwsh Tests/Test-Xml.ps1` rerun today, PASS. Pickle suite written (6 features, no @wip), passes declared in TESTING.md. Missing: `TEST_SCENARIOS.md` (7.a), tested sha (7.f).
  - `playTests` (8): not reached. 02-forage-vef and 07-galerie never played green, no code review (`code_review_sha` absent, 8.m).
- Not done: no game run, no Pickle ticket in queue for this mod, no file under `Mod/` changed.

### Audit 2026-10-10, update after the icon replacement (revision 7b3f83a + working tree)

`makeSources -> code` now established: source 1219 x 1290 with alpha (2.a), derivatives regenerated (2.b), icon legible at 32 px by my reading, awaiting Virginie (2.c), no `PROMPT_*.md` (2.d), Preview-source unchanged and previously accepted (2.e: 1 hue family, Vmean 0.920 measured on source). `Art/.render/` git-ignored (2.f). Retained state now `writeTests[1.0.0]`: first failing transition `writeTests -> playTests` (no `TEST_SCENARIOS.md`, tested sha not recorded). Session title `animalsnaturally / writeTests[1.0.0]`.

### 2026-10-10: writeTests -> playTests[1.0.0]

Criteria 7.a to 7.i checked: TEST_SCENARIOS.md written, Test-Xml.ps1 rerun green with new assertions, Pickle suites written, not-applicable cases justified in TESTING.md, tested sha recorded in TEST_SCENARIOS.md, translations `not_applicable`. Protocols marked read (protocols_read_sha, see front matter). Tickets filed for what has not run green on current suite: `06-valeurs` (second scenario) and `02-forage-vef`. `07-galerie` = shootGallery work, not filed at this state.

### Code review (AUDIT 8.m), 2026-10-10, e656137..88b3028

Scope: `git diff e656137 HEAD -- Mod Tests`. `Mod/Patches/` byte-identical to 0.1.0 upload (nothing to review in ten patch files beyond what offline and Pickle runs exercise). `Mod/About/About.xml`: description text only (adoption clause, AI notice, linked THANKS), no metadata change. `ModIcon.png` and `Preview.png` derived outputs. Tests: `Test-Xml.ps1` assertions verified by negative run; features 02, 06, new 07 read. Findings, none blocking: (1) About.xml still says "a macaw lives for 55 years" (Lifespan.xml has no Macaw entry), fix with description sync at writeDocs; (2) `Test-Xml.ps1` asserts BBCode `[url=...]Source code on GitHub[/url]` form in description, which generated About.xml description (plain text, "Source code on GitHub (URL)") will not have: update assertion in same commit as sync; (3) 02-forage-vef counts 7 scenarios, not 12 I declared with -Tests (12 included other files of pass). Later commit of `Mod/` (About.xml sync) reopens criterion for that diff only.

### 2026-10-10: playTests -> shootGallery[1.0.0]

8.a to 8.n checked: sha frozen, conditional passes 02 to 06 played green, no @wip, no @review scenario, no manual test left, evidence minified (`summary.json`, `junit.xml`, `summary.md`, `evidence-complete.txt` only), `tested_on` filled, code review done. Settings and translations `not_applicable`, so no FR/EN replay.

### shootGallery, 2026-10-10: series rebuilt for Nelim's Sanctuary

`Tests/Pickle/Mod/Pickle/Features/07-galerie.feature` rewritten (045b5ad) after GALLERY.md and Backlot docs: three pictures, one morning (10:00, 10:05, 10:10, cumulative waits 60, 268, 477 ticks), shot plan in feature header. 1 enclosure-south: elephant, horse, cow, hen at real scale; 2 flower-garden: Health tab of horse (menu); 3 plant-garden: hungry royal pheasant (VAERoy). `wsl-deps.galerie.map` rebuilt from Backlot minimum list. Ticket c9ed (galerie-1) failed at staging (infrastructure, nothing played: see docs/runs/history.md), refiled as `20261010-213323-044-e7d3` (galerie-2, 3 tests), evidence `Tests/Pickle/Evidence/galerie-2`. Candidates go to `Art/gallery/<n>-candidate-<name>.png` once images opened and read; Virginie accepts or refuses. Not played yet. Gallery table (PUBLICATION.md, STATUS.md) stays "scenario written, not played" until then.
## Shotlist (AUDIT 9.0), reworked 2026-10-18 against GALLERY.md a to j (Audit relay)

Story and every field per scene: header of `Tests/Pickle/Mod/Pickle/Features/07-galerie.feature`. One day at the Sanctuary: 08:00 feed round (scale), 11:00 field-notes card (interface, set aside), 15:00 hungry grizzly. Outfit, hair, face, decor differ per scene; decor removed after each shot. The scenarios of 07-galerie still follow the OLD plan (pheasant, old outfit): rewrite them to the header before any ticket (after reading probe-0/300/1200 of galerie-9, 620b), then delete `probe`.

| # | Scene | Place, hour | Score | Risk | Plan |
|---|---|---|---|---|---|
| 1 | Feed round: Nelim (sage shirt, khaki trousers, ponytail, calm) carries Hay among elephant, hen, horse, cow | enclosure-south, 08:00 | 4 | green tint on left ground, animals overlapping | no bared floor unless the tint is gone; ask NPT via TM; stagger animals 3+ cells in depth |
| 2 | Horse Stats card | window-backdrop-for-height, 11:00 | n/a (interface, set aside) | HUD left around the window | crop sideways by hand, no subtitle |
| 3 | Hungry grizzly digs, Nelim (ochre duster, bun, raised brows) watches with a field kit | plant-garden, 15:00 | 4 | the dig is not visible (unproven); grizzly turns on Nelim | probe frames decide the tick; fallback RawBerries via StageDecor; player faction, 5 cells apart |

Hats: none worn in any scene, hair-under-hat rule not triggered (if one is added: long loose hair, hair-under-hat mod in the DepMap). k (story): header tells one story (who Nelim, where the Sanctuary, one clear day, hours 08:00, 11:00, 15:00 by 2,500 ticks per game hour), each scene an episode: met. Lowest scored scene: 4. Series is thin (two story scenes plus the card): one more scene (calf beside a cow for gestation, or hybrid) possible after these two play green; not written, no extra risk taken. Nothing is played yet under the new plan.

Open 2026-10-18 (state before clear): ticket galerie-9 (620b) ended exit 3, startup never finished (no report); probe refiled alone as galerie-10 (694c, `07-galerie::probe`, -StallMinutes 20 -RunTimeoutMinutes 25), evidence `Tests/Pickle/Inbox/galerie-10`, waiting. On RUN_DONE: read probe-0/300/1200, then rewrite scenario 3 to the header (grizzly, 15:00, plant-garden), delete `probe`, file one ticket for scenarios 1 and 3 (not played under the new plan). NPT contact only if the green tint or no-power icon persists on a new capture, or the staging `rm` failure recurs. Shotlist scores 4 and 4 (above); PUBLICATION.md "Staging of the gallery" stale; then reindex, Art/Gallery-clean, Add-Subtitle, echo review.

Open 2026-10-23 (galerie-11, 6904, read): exit 1, 2 passed 1 failed. probe passed: grizzly stands from tick 0, a forbidden RawBerries stack (red X) appears under it at 300, the grizzly is gone at 1200; the dig itself is not seen, so scene 3 needs the grizzly digging at about tick 300 with Nelim closer (she is 12 cells away, off the shot). workshop-1 passed but green tint on the left ground persists (refused): anomaly relayed to NPT via TM 2026-10-23. workshop-2 failed: Horse spawn "no clear area within 16 cells of (90, 0, 140)" on window-backdrop-for-height, relayed to NPT via TM. New rule 2026-10-23 (GALLERY.md d, e): a pawn keeps the same outfit through one story (the day), unless the plan justifies a change; the shotlist above has a different outfit per scene and must be rewritten (one outfit for the whole day, or a stated change); e = "game paused" instant (just before / just after, how the gesture is obtained). Next: rewrite shotlist (Opus sub-agent, 9.0) to the new rules, wait for NPT, delete probe, refile one ticket. Inbox/galerie-11 kept (screenshots) until scenes are redone, heavy files deleted.

## Shotlist 2026-10-23 (supersedes the table of 2026-10-18 above; Opus director pass kept in part)

Story and outfit: header of `07-galerie.feature`. One outfit all day (sage shirt, khaki trousers, Roo_HD_Hair_Highpony, calm face, no hat). Jobs given, game paused a few ticks in (e).

| # | Scene | a | b | c | d | e (instant, how) | f | g | j | Est | Risk | Plan |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | feed round (opener, wide) | enclosure-south, 07:00 Clear, 60+40 ticks | Hay stack, EggBox, Plant_YellowTallGrass nest, removed | elephant S, horse S, cow W, hen S (3 from the front) | outfit above | just after the hay drop: Nelim Goto toward EggBox mid-stride, cow Ingest on the Hay, pause ~40 ticks | rectangle (140,209)-(162,219), Nelim off-centre, hen foreground | Nelim is the yardstick | size of 4 species | 4 | tint (zones), job poses unproven | `the painted zones are hidden`; if the tint stays NPT writes a step for home/allowed area; no Hay/jobs = stand and carry |
| 2 | elephant Stats card (interface, set aside, no subtitle) | window-backdrop-for-height, 11:00 | n/a | n/a | n/a | n/a | cropped sideways | her notes: the numbers behind 1 | size, lifespan | n/s | Horse/elephant spawn "no clear area" | spawn named animal on a known free cell, then `stands on the nearest free cell around (90, 140)` |
| 3 | cat asleep at noon (close) | sofa-corner, 13:00, zoom 3.5 | sofa, book | vanilla Cat (Nocturnal in Rythme.xml) asleep, Shogun awake and facing camera | outfit above, seated | just after she sits to read: cat LayDown on the sofa, Nelim ReadBook, run until not standing | tight, cat off-centre | cats keep the night | rhythm | 3 | LayDown and ReadBook jobs unproven, rhythm only in the subtitle | ask NPT for job steps; reuse CreaturesOfKi `lies down to sleep` pattern |
| x | taming then hybrid (DROPPED 2026-10-23, no steps; the grizzly became 4) | gravel-yard, 15:00 | none yet | ibex (Tame job) and a newborn hybrid pair taken from Hybridation.xml | outfit above | Tame job paused at the interaction icon; hybrid just after birth | medium | taming and hybridisation | gestation, hybrid | 3 | no hybrid pair chosen, Tame job unproven, may need two scenes | read Hybridation.xml for a pair that exists in the DepMap, ask NPT for Tame and birth steps; else drop |
| 4 | grizzly at dusk (closer, was 5) | plant-garden, 18:30 (Bear_Grizzly is Crepuscular), StandingLamp lit | StandingLamp lit, PlantPot Daylily, removed | Bear_Grizzly food 0 %, faces South | outfit above, MedicineHerbal kit | Nelim Goto home past the bear, bear Ingest on RawBerries, pause ~60 ticks | medium-wide, bear off-centre | a hungry grizzly digs | forage | 3 | the dig is not seen (galerie-11 probe), red X on berries, a staged bear eating proves no forage | NPT: is there a visible stage of the dig with berries produced, unforbid step, hide forbid icon; else forage only in the subtitle (j fails at 268 px) |

k (series): one story, wide opener (1), close middle (3), medium closer (5), rhythm 07:00 to 18:30, outfit continuous. Series score 3 while 3, 4, 5 sit at 3. Only 1 and 2 can be filed (1 = 4, 2 interface): no ticket for 3, 4, 5 below 4. Not kept from Opus: hour 06:00 and `enclosure` zoom 18 for scene 1 (animals too small at 268 px, enclosure-south zoom 12 kept), horse card replaced by elephant card (kept).

Revision 2026-10-23b (NPT answer, steps that exist, all unplayed): walk = `"X" is forced to walk to (x, z)` (drawn only while ticks pass: let N ticks pass, then pause); `"X" lies down` (on its own cell, move it first); missing: seated ReadBook, animal Ingest, LayDown on a building, birth; unforbid asked of NPT (`the item "def" at (x, z) is unforbidden`). Scenes reworked on those: 1 drops the cow Ingest (cow stands by the Hay, Nelim walks); 3 = Nelim tiptoes past the sleeping cat toward the door (walk), the cat `lies down` on the floor or rug (no sofa), Shogun faces South, score 4; 4 (taming, hybrid, birth) DROPPED, steps missing, Tame icon unproven; 5 = grizzly just after the dig, captured at tick 300 (probe-300 showed the berries under it), faces South, berries unforbidden (NPT step), Nelim walks, no Ingest, score 4 once the unforbid step exists. Scores: 1 = 4, 3 = 4, 5 = 4 (conditional), 2 interface. Series = opener 1, middle 3, closer 5. Files to file: 1 + 2 now, 3 after rewrite, 5 after the unforbid step.

Filed 2026-10-23 (c7492f8): galerie-12, ticket 20261023-190305-408-0600, scenes 1, 2, 3, 5 of 07-galerie, evidence Tests/Pickle/Inbox/galerie-12, waiting. On RUN_DONE read summary.json, then each capture against the shotlist; scene 5 first screenshot is before the unforbid step (stack cell (193, 85) is a guess). Inbox/galerie-11 still kept for its probe frames.

Reindexed 2026-10-23 (owner): scenes are now 1 feed round, 2 elephant card, 3 cat asleep, 4 grizzly at dusk (was 5); the taming/hybrid scene is dropped, no gap. Scenario "workshop 4", captures workshop-4-before-unforbid and workshop-4-grizzly-dusk. Ticket 0600 cancelled while pending (filter named workshop 5) and refiled.

## Shotlist 2026-10-23c, shots 1, 3, 4 reworked (write-shotlist 1, 3, 4)

One story, one outfit (Pants khaki rgb(176,150,100), CollarShirt sage rgb(96,128,84), Ponytails, hair rgb(70,48,34), face kit calm). Every shot now writes what each living thing does, the instant, how it is obtained (forced to walk, ticks, pause), the pixel size at 268 px. Shot 2 (elephant Stats card, 11:00) is an interface window, listed apart.

| # | a | b | c | d | e | f | g | j | Est | Risk | Plan |
|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | enclosure-south, 07:00 Clear, 60+30 ticks | EggBox, Plant_YellowTallGrass, Hay, removed | elephant S, horse S, hen S, cow W | outfit above, calm | cow, hen and Nelim forced to walk, just after the hay drop | 19 x 10 cells, hen and Nelim foreground, elephant back left | Nelim is the yardstick | elephant 42 px, cow 28, Nelim and hen 14 at 268 px | 4 | green tint | painted zones hidden; NPT writes a step if it stays |
| 3 | sofa-corner, 13:00 Clear, 60+40+30 ticks | Couch x2, TorchLamp, BookcaseSmall, PlantPot (already there) | Cat S, Zzz mote | outfit above, calm | cat lies down, Nelim leaves without waking it (forced to walk) | 7 x 5 cells, cat foreground low left, Nelim behind row 126 | cats keep the night | cat 30 px at 268 px, subtitle carries the rhythm | 4 | LayDown on its own cell, no sofa; Zzz not proven | read the capture, move the cat to a free cell if it stands |
| 4 | plant-garden, 18:00 Clear, 60+270+30 ticks | TorchLamp lit (189,89), removed | Bear_Grizzly S, garden plants | outfit above, calm | dig just finished, bear over the pile; Nelim slows by it (forced to walk) | 10 x 6 cells, bear and pile off-centre right, Nelim mid-left, lamp pool | a hungry grizzly digs | bear 50 px, pile 25 px, subtitle carries the forage | 4 | red X on berries; pile cell (193, 85) is a guess; bear 3 cells from Nelim | first screenshot before the unforbid step names the cell; player-faction bear |

k (series): unchanged, wide 1, close 3, medium 4, 07:00 to 18:00. Ticket galerie-12 (7545) still pending, picks this tree.

State 2026-10-23 (watch-out): galerie-12 (7545, 07-galerie workshop 1, 2, 3, 4) pending in the queue behind about 20 tickets, evidence Tests/Pickle/Inbox/galerie-12. Plan rated with rate-gallery after the owner removed the anomaly cap (asked of Audit to remove it at the source): shots 1 = 4.5, 3 = 5, 4 = 5, mean 4.8. On RUN_DONE: summary.json, then each capture against the shotlist (tint, red X, cat lying, bear distance), then reindex, Art/Gallery-clean, Add-Subtitle, echo review. Open: PUBLICATION.md thanks and gallery fixed 2026-10-23, FRENCH_REVIEW.md committed (no player-facing strings).

Before clear 2026-10-23: nothing owed by the owner. Pending from others: galerie-12 (7545) RUN_DONE via TM; Audit answer on any remaining score cap in other skills (rate-gallery caps already removed at the source); NPT only if the tint or the red X persists on a galerie-12 capture. Mod repo pushed (master to origin/main).

Open 2026-10-24 (galerie-12, 7545, read): exit 1, 3 passed 1 failed. Shot 1 feed round: green tint under and left of the elephant persists, animals spread wide, tiny at 268 px: refused again, NPT asked via TM for the tint (zones). Shot 2 elephant card: readable, HUD box bottom-left, crop sideways by hand, no subtitle. Shot 3 cat asleep: cat lying with Z, Nelim passes behind the bookcase row, outfit continuous: kept as Art/Gallery/3-candidate-cat-asleep.png (1.5 MB), awaiting the owner. Shot 4 grizzly: FAILED at "the animals of kind Bear_Grizzly have food at 0 percent": "no animal of kind Bear_Grizzly named coat-N is on the map" (spawn named "bear" is renamed coat-N by Pickle, the food step does not find it; also the step filters by kind). Relayed to NPT via TM. Inbox/galerie-12 kept (screenshots) until shots 1 and 4 are redone, heavy files to delete.

State 2026-10-25 (watch-out): galerie-13 (e7d9, 07-galerie workshop 1, 3, 4, commit e90f940) pending in the queue, evidence Tests/Pickle/Inbox/galerie-13. Changes since galerie-12: smile (MouthSmile, LidCheerful) in 1 and 3, MouthLipsTinySmile in 4, cat of 3 is Tama (akaNEKO_N_Forest_Cat, Let's Have a Cat! Continued 3682940618 added to wsl-deps.galerie.map), pollution cleared in 1 (NPT lead for the tint), `the animal "bear" has food at 0 percent` in 4. Unverified: akaNEKO kind name, MouthSmile resolving with the VTE pack, smile surviving the 30 walk ticks, NPT steps b1413ce never played. Plan rated 4.5 / 4 / 4.5 (mean 4.3, rate-gallery 2026-10-25). Candidate Art/Gallery/3-candidate-cat-asleep.png is from galerie-12 (vanilla cat), to be replaced by the galerie-13 capture. On RUN_DONE: summary.json, each capture against the plan, then reindex, Art/Gallery-clean, Add-Subtitle, echo review.

Open 2026-10-29 (galerie-13, e7d9, read at resume): exit 1, 2 passed 1 failed. Shot 1 feed round: grey tint left of and under the elephant persists (pollution step did not clear it), animals spread wide, Nelim face reads as a flat orange blob (smile not visible): refused again. Shot 3 cat asleep: cat lying with Z on the rug, Nelim passes behind the bookcase row, kept as candidate pending the owner (face again a flat blob, smile not visible). Shot 4 grizzly FAILED at `"Nelim" stands at (190, 87) facing West`: "the cell (190, 87) is not standable": pick a standable cell next to the bear. Inbox sorted 2026-10-29 (TM relay): galerie-11, 12, 13 all red and studied, deleted; the galerie-13 cat capture (Tama) copied over Art/Gallery/3-candidate-cat-asleep.png (replaces the vanilla-cat one), shot 1 capture refused and deleted, Inbox empty. Next: fix cell for shot 4, ask NPT about the tint and the faces, refile shots 1 and 4.

Open 2026-10-29 (NPT answer, via TM): faces: the flat blob at 268 px is a resolution limit (smile 1-2 px), no face kit fixes it. Options: (a) keep the wide shot and add a second shot on the head with `the camera frames the head of "Nelim" at root size {float}` (smaller = closer, Pickle's closest 12); (b) `I frame the cells (x, z) to (x, z) filling {int} percent of the screen` around Nelim. Do not hold the face neutral if a smile is wanted. Steps exist, unplayed at our cells. Plant-garden standable cells and the grey tint are NSB's: NPT forwarded both, NSB answers this session directly. NSB lead on the tint: filth (grey-brown patches), not cleared by the pollution step. Added `all filth is cleaned` to shot 1 (4791d8c); ticket galerie-14 (72fd, `07-galerie::workshop 1`, evidence Tests/Pickle/Inbox/galerie-14) filed 2026-10-29, waiting: KEEP the capture. Shot 4 cell: NPT step `the free standable cells of the area from (x, z) to (x, z) are listed` (257ac6a, compiled not played, writes `[free-cells]` lines to the game log); probe scenario `07-galerie::cells` written (b6902e2), not filed: asked NPT where the log lines land in the Inbox, file when answered, then delete the probe. Was: NSB asked NPT for a step listing free standable cells of a rectangle, run it on (186..196, 83..89) when it exists. Then fix shot 4 cell, decide with Virginie whether a head shot joins the series (series change), refile.

State 2026-10-29 (sleep): probe ticket filed, `20261029-223634-388-d340` (`07-galerie::cells`, `-DepMap wsl-deps.galerie.map`, evidence `Tests/Pickle/Inbox/cells-probe`), waiting behind galerie-14 (72fd). NPT 8e5962e: the free-cells step now also calls `ctx.Attach("free-cells", listing)` (compiled, not played). On RUN_DONE: read summary.json, then list the Inbox files and look for "free-cells" (summary.md or junit.xml guessed, not verified); if absent, send NPT the file list. Then fix the shot 4 cell, delete the `cells` probe, refile shots 1 and 4. Protocols read at 0de16458.
