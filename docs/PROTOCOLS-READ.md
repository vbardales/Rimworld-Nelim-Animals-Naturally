# Protocol reading record

Last reading pass: 2026-09-26 (Europe/Paris). Last verification: 2026-09-29.

This record identifies the exact documentation snapshot used for this checkout. The
shared protocol Git history did not expose commits for the listed working-tree files,
so those files are recorded by SHA-256. A hash change requires a new reading pass.

## Read and applicable

| Document | Version read | Why it applies |
| --- | --- | --- |
| Session-supplied `AGENTS.md` | 2026-09-26 instruction payload; no on-disk file | Ordered settings, localisation, evidence, and CI rules. |
| `../AUDIT.md` | SHA-256 `D5DC23B06E35F79B2EE5E7D52AB25132AB45D517962C31A3C19D1D1445D5B740` | Evidence-based workflow, stage gates, and game-run safety. |
| `../MOD_SETTINGS.md` | SHA-256 `404916BC99A7F1C6FC00D7AB51D417F86FC719AB62AF023C4022F502D7A9F2C6` | Settings decision and `not_applicable` standard. |
| `../PUBLISHING.md` | SHA-256 `7D34F55D583D7F657CC66B899CA7D5D385584C02D1D138AF40AFE1A7D204342A` | Public-repository, metadata, licence, and release requirements. |
| `../TRANSLATIONS.md` | SHA-256 `298F74D226DA2C4B9365D65A82275D0FE80C7EDB3FE08910F6B452FBAD945792` | English/French coverage and justified exclusions. |
| `../STYLE_RIMWORLD.md` | SHA-256 `DE13CBE5E1F978B7357EADEDFC2DF035B857E3641B0023FD2DA6E44985FFB205` | Title and artwork conventions. |
| `../scripts/SEARCHING.md` | SHA-256 `9DBD52B2BCD4BA66C7465C02C0E9C816B24F4251C0FD447561A315DFC15D20B4` | Corpus-search coverage and interpretation rules. |
| `../PickleTools/README.md` | `c771befc513e872b5e07c6cc1b3a68318c7e8d6a` (2026-09-25) | Shared Pickle tooling and one-step/one-owner rule. |
| `../PickleTools/Headless/README.md` | `cfa7aac685ac7250918c41aaa332ff0aab2b6bcb` (2026-09-26) | Headless staging and report-handling rules. |
| `../PickleTools/docs/steps.md` | `cba3ca1b20527481874b3012266a060e07c19484` (2026-09-25) | Required catalogue lookup before writing a Pickle step. |
| `../Rimworld-Ticket-Dispatcher/docs/WELCOME.md` | `84a20e65e8807f52b465d619b15f903eddc44677` (2026-09-26) | Dispatcher-only submission and notification model. |
| `../Rimworld-Ticket-Dispatcher/docs/SUBMIT.md` | `c0a73a2d40d498a5470007b4fb0f7f13f5b97e16` (2026-09-25) | Request arguments, evidence paths, and exit-code interpretation. |
| `STATUS.md` | SHA-256 `96F3A521A970303CDB28BE08F2D536951FF293EB7FD3350CD71108AB6AED0C79` | Current stage, evidence, and outstanding work. |
| `README.md` | SHA-256 `25A7B780418EE60FDD3FA1162F0322AA21D5BCCDA4AB7E10E87C00E588C0E209` | Public project description and dependency claims. |
| `CHANGELOG.md` | SHA-256 `AD295DFD466713F0B919A34C502030197386995AE3C585B091288B945BD4E85C` | Recorded rename and audit changes. |
| `ATTRIBUTION.md` | SHA-256 `57335B24101A3583499ECA3714D1267E1C620468CC8DA9957A9F3C66DF1715D5` | Rights boundary and acknowledgements. |
| `LICENSE` | SHA-256 `1B1595676D60B1B917F04EF1E531934E3C8B01930912B710A5AE1DCE2B818D9F` | MIT scope. |
| `Mod/About/About.xml` | SHA-256 `4ADB5EA9DAEF2F5454E50CD5EFE5C06270E218EA9B6CE8910BDF5C2B85A53A02` | Delivered identity, dependency, and Workshop-description contract. |

## Read but not currently useful

These documents were read for this pass but do not govern an action currently in
scope. Do not reread them solely because they change; reread them when their trigger
condition applies.

| Document | Version read | Reread trigger |
| --- | --- | --- |
| `../WORKSHOP_COMMENTS.md` | SHA-256 `6C69A05BB42493305B2400FE39A2CFF2FF3A9196B3FD2F2671429816B39D3C69` | Drafting or posting a Workshop acknowledgement. |
| `../Rimworld-Release-Admin/docs/OPERATIONS.md` | `f196148a21c0df1996931726678325d90114f2fd` (2026-09-25) | Any CI workflow, dry run, tag, release, Steam secret, or publication operation. |

## Requested paths absent in this checkout

The following were checked on 2026-09-26 and were absent; their absence is itself
current evidence, not a successful substitute for their future contents.

- `AGENTS.md` on disk (the session instruction payload was read instead)
- `PUBLICATION.md`
- `TESTING.md`
- `BACKLOG.md` (the mod-local file)
- `docs/runs/`
- `Tests/Pickle/`
- `NOTES.md`
- `BUGS.md`

No test report or run-history evidence was deleted or created in this pass.

## Local documents created after this reading pass

`TESTING.md` was created and read on 2026-09-26 to record the test gate and
evidence-retention policy requested after this pass: SHA-256
`2A979BA951FD78052550C76056DA19DB54CBAA657B52B238BE6C709B3ADFF5C4`.

## Verification reading — 2026-09-26

Every requested path above was read again. The recorded hashes remain current for the
shared protocols and local mod files; the requested test and publication paths remain
absent. The session-supplied `AGENTS.md` remains the applicable instruction because no
on-disk `AGENTS.md` exists in this checkout.

For the current static-audit work, these previously read documents are **not useful**
unless their trigger occurs; do not reread them merely because they change:

- `../WORKSHOP_COMMENTS.md`: drafting or posting a Workshop comment.
- `../Rimworld-Release-Admin/docs/OPERATIONS.md`: a CI, tag, release, secret, or publish action.
- `../PickleTools/README.md`, `../PickleTools/Headless/README.md`, and
  `../PickleTools/docs/steps.md`: creating, editing, staging, or interpreting a Pickle suite.
- `../Rimworld-Ticket-Dispatcher/docs/WELCOME.md` and `docs/SUBMIT.md`: submitting or
  interpreting a queued game run.
- `../scripts/SEARCHING.md`: a corpus-wide source or binary search.

## Verification reading — 2026-09-29

Recomputed SHA-256 for every "Read and applicable" / "Read but not currently useful" doc above
(`certutil -hashfile <path> SHA256`, so case differs from the 2026-09-26 table but the digest is the
same when unchanged):

| Document | 2026-09-26 hash still current? | Action |
| --- | --- | --- |
| `MOD_SETTINGS.md` | Yes | none |
| `TRANSLATIONS.md` | Yes | none |
| `Mod/About/About.xml`, `ATTRIBUTION.md` | Yes | none |
| `AUDIT.md` | **No** | re-read this pass (stage chain `dansMonoRepo → … → published`, full gates); nothing found that invalidates prior decisions in this repo |
| `PUBLISHING.md` | **No** | re-skimmed the CI-publishing section again this pass; no publish action taken |
| `STYLE_RIMWORLD.md` | **No** | this file now covers full 3D "vitrine" showcase scenes (camera/negative-prompt blocks for AI-rendered dioramas); does not apply to this mod's `Art/preview.html` text-overlay card, which has no diorama. Not reread in full. |
| `scripts/SEARCHING.md` | **No** | reread in full this pass |
| `WORKSHOP_COMMENTS.md` | **No, and it's the one that matters** | see below |

**Important finding, worth keeping:** commit `90d51374` (2026-09-25, monorepo root) untracked
`AGENTS.md`, `AUDIT.md`, `PUBLISHING.md`, `TRANSLATIONS.md`, `STYLE_RIMWORLD.md`, `MOD_SETTINGS.md`,
`EXTERNAL_TOOLS.md`, `scripts/PICKLE-WSL.md`, `scripts/SEARCHING.md` and `scripts/Tests/README.md`
from this repo's git history — the files stay on disk but a separate "protocols repository" now owns
and edits them, invisibly to `git log` here. **`git diff <old-commit> -- <path>` on any of them shows
nothing even when the live content changed**: the SHA-256 re-check above is the only way left to
detect drift on these files from this repo. `WORKSHOP_COMMENTS.md` is the one exception: it stayed
tracked (real, git-visible history, `+109/-13` since `90d51374`), so treat it like a normal file.

`WORKSHOP_COMMENTS.md` moved from "not useful this pass" to actually used: on 2026-09-29 this mod was
added to `Covers` for its already-posted recipients (Nocturnal Animals, Vanilla Expanded Framework,
Pickle, RimLogging, PickleTools) and three new `drafted` rows were added for the animal packs
Forage.xml genuinely patches (Animals Forage, Alpha Animals, Vanilla Animals Expanded) — see
`PUBLICATION.md` in this repo. Its trigger ("drafting or posting a Workshop acknowledgement") has now
occurred; reread it again before the next posting round, its own method section was refined
2026-09-26 and may move again.

`Rimworld-Ticket-Dispatcher/docs/WELCOME.md` and `docs/SUBMIT.md`, and `PickleTools/README.md`,
`PickleTools/Headless/README.md` and `PickleTools/docs/steps.md`: all five triggers also occurred
this pass (creating `Tests/Pickle/`, submitting real runs, using PickleTools' opt-in `DefFields`
companion for the typed value step). Their 2026-09-26 recorded state is no longer "not useful" —
treat them as live working references for this mod from now on rather than re-verifying their hash
each time; PickleTools especially moves often (a companion, `DefFields`, was added between the two
reading passes).

`Rimworld-Release-Admin/docs/OPERATIONS.md`, `../WORKSHOP_COMMENTS.md`'s own "Register" table
entries not touched by this mod: still not useful, no CI/publish action taken this pass either.

The session-local `docs/notes/docs-read.md` file (created 2026-09-27 by an earlier pass of this mod)
duplicated this record and had already gone stale in the opposite direction (marking things "not
needed" that this pass then used); it was deleted 2026-09-29. This file is the single source of truth
for what's been read and why, going forward — do not recreate a second one.

## Reading pass — 2026-10-01

Read in full: `../AUDIT.md` (275 lines; new since 2026-09-29: prepublication `0.1.0` rules, `tested` criteria no `@wip` / every conditional scenario run / no manual test left, evidence on disk only, one `docs/runs/` line per run, `Submit-PickleRun.ps1` with a new `-EvidenceDir` every time, session title `<packageId sans nelim.> / <workflow_stage>`), `../Rimworld-Ticket-Dispatcher/docs/SUBMIT.md` (options table, exit codes). Hashes recomputed (first 16 hex digits; the 2026-09-29 table above used full digests): AUDIT `0fb60fdf8c87c920`, MOD_SETTINGS `404916bc99a7f1c6` (unchanged), PUBLISHING `0bcad17895950`, TRANSLATIONS `e5197820fda1bfb2`, STYLE_RIMWORLD `e5326fd6cf754614`, WORKSHOP_COMMENTS `3fb37586f04b8edc`, SEARCHING `013075b06b89fe59`. Monorepo siblings now at: PickleTools `b7620cb` (2026-09-29), Rimworld-Release-Admin `d5282af` (2026-10-01), Rimworld-Ticket-Dispatcher `ae69394` (2026-10-01). `AGENTS.md` now exists on disk (`../AGENTS.md`).

Not reread this pass, no trigger: `PUBLISHING.md`, `TRANSLATIONS.md`, `STYLE_RIMWORLD.md`, `MOD_SETTINGS.md` (this mod: no settings, no text, no new art made), `WORKSHOP_COMMENTS.md`, `Release-Admin/docs/OPERATIONS.md`, `scripts/SEARCHING.md`, `PickleTools/*`, `Ticket-Dispatcher/docs/WELCOME.md`. Reread `PUBLISHING.md` + `OPERATIONS.md` before the first CI publish, `WORKSHOP_COMMENTS.md` before posting.

Absent in this checkout (checked 2026-10-01): `BACKLOG.md`, `NOTES.md`, `BUGS.md`. Present: `STATUS.md`, `README.md`, `CHANGELOG.md`, `ATTRIBUTION.md`, `LICENSE`, `PUBLICATION.md`, `TESTING.md`, `docs/runs/`, `Tests/Pickle/`, `Mod/About/About.xml`.
