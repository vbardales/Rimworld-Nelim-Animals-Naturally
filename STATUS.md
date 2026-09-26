---
mod: "Nelim's Animals, Naturally"
packageId: nelim.animalrebalance
repo: https://github.com/vbardales/Rimworld-Nelim-Animals-Naturally
visibility: private
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
  - pending: publication-history audit and explicit approval to change the GitHub repository to public
  - defect: Preview.png still displays the former French title and French copy
  - pending: test plan and automated/XML patch-target tests before preTest
  - pending: non-WIP scenarios for every applicable conditional patch family
  - pending: executed results for every conditional scenario and a completed manual-test checklist before tested
updated: 2026-09-22
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

The repository remains private. Public visibility is the stated project intent, but changing
a formerly private repository to public requires an audit of its complete history and a fresh,
explicit approval for that irreversible disclosure.

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
