# Protocol reading record

Last reading pass: 2026-09-26 (Europe/Paris)

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
