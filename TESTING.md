# Testing and evidence retention

## Current status

No automated test suite, Pickle suite, manual-test checklist, or test evidence directory
exists in this checkout as of 2026-09-26. No test has been run for this revision.

`@wip` is absent only because there are no Pickle feature files. That is not evidence that
the required functional scenarios have been written or passed.

## Requirements before `tested`

- Write scenarios covering every conditional patch family and its applicable dependency
  combinations.
- Keep no scenario tagged `@wip` in the validation suite.
- Execute every conditional scenario relevant to the delivered revision and retain its
  terminal result.
- Record every required manual validation, run it, and leave none pending; all recorded
  manual checks must be green.
- Run the required English and French passes for any player-facing text that is introduced.

## Evidence to keep locally

Evidence remains on disk and is ignored by Git. Before deleting anything, list the files
that will go and the files that remain; repoint `STATUS.md` first if it names a file.

For each scenario and exact revision, keep only the newest terminal report that proves the
current check: `summary.json`, `junit.xml`, and only the `@review` screenshots needed to
show the claimed visual result. Keep an older report only when it is the sole proof of a
check not repeated by the newer run. Do not retain superseded `report.html`,
`messages.ndjson`, complete shared Pickle archives, or `Player.log` unless one is the sole
evidence of a failure diagnosis. Summarise retained runs as one text entry in `docs/runs/`.

## 2026-09-26 retention decision

- Delete: nothing. No `Tests/Pickle/Evidence/`, `evidence/`, or `.dds` file exists in this
  checkout, and no such path is tracked by Git.
- Keep: nothing. There is no test evidence for this mod yet.
