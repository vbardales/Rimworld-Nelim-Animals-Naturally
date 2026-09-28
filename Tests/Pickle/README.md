# In-game scenarios, run by Pickle

Written 2026-09-28. **Not run yet on any revision**: see `../../TESTING.md` and `../../STATUS.md` for the state of each pass.

A suite of five features run inside a running RimWorld by [Pickle](https://github.com/RimWorks/Rimworld-Pickle)
(`rimworks.pickle`, Workshop 3791648678). It compiles nothing: every step is built into Pickle
(`mod "X" is loaded`, `mod "X" loads after "Y"`, `def "X" of type "T" exists`, `def "X" was patched by mod "M"`,
`no def "X" was patched`, `no warnings from mod "M"`, `no errors were logged`).

`Mod/` is a companion mod, **Animals Naturally - Pickle tests**, never published, that holds the feature files so
that nothing test-related ships in the Workshop payload. `Mod/Languages/README.md` is there only so that RimWorld does not log
"did not load any content" for the companion (same trick as `TechLevelFixes`).

## Three passes

`AUDIT.md` asks every mod for a pass without its optional mods and one with them, and a pass per set of optional mods that cannot
share a list. Nothing here is declared incompatible and the mod has no DLC guard, no text and no setting, so there is no
incompatibility pass, no DLC-absent pass and no language pass (justification in `../../TESTING.md`).

| Pass | Map | Filter | Features |
|---|---|---|---|
| `sans-facultatifs` | none | `01-baseline` | `01-baseline` (the others are skipped by `@requires`, and must be seen skipped) |
| `avec-vef` | `wsl-deps.avec-vef.map` | `Animals Naturally - Pickle tests,!01-baseline` | `02-forage-vef` |
| `avec-loadafter` | `wsl-deps.avec-loadafter.map` | `Animals Naturally - Pickle tests,!01-baseline` | `03-dogsmate`, `04-rotten`, `05-zoology` |

`01-baseline` asserts that the optional mods are absent, so it must not run in the other two passes; the features of the other two
are tagged `@requires:<packageId>`, so they are skipped (and counted as skipped, which is not a pass) in the bare pass.
`wsl-ids.map` resolves the Workshop id of the one hard dependency, Nocturnal Animals, in every pass.

A session does not launch the game: it files a request (`AUDIT.md`, "Deposer un run au lieu de le lancer") and reads the report
when the run is done. From the monorepo root:

```powershell
powershell.exe -ExecutionPolicy Bypass -File Rimworld-Ticket-Dispatcher\scripts\Submit-PickleRun.ps1 `
  -Mod AnimalsNaturally -Owner local_<session id> -Label "sans-facultatifs <sha>" -Filter '01-baseline' `
  -EvidenceDir AnimalsNaturally/Tests/Pickle/Evidence/sans-facultatifs

powershell.exe -ExecutionPolicy Bypass -File Rimworld-Ticket-Dispatcher\scripts\Submit-PickleRun.ps1 `
  -Mod AnimalsNaturally -Owner local_<session id> -Label "avec-vef <sha>" -DepMap wsl-deps.avec-vef.map `
  -Filter 'Animals Naturally - Pickle tests,!01-baseline' -EvidenceDir AnimalsNaturally/Tests/Pickle/Evidence/avec-vef

powershell.exe -ExecutionPolicy Bypass -File Rimworld-Ticket-Dispatcher\scripts\Submit-PickleRun.ps1 `
  -Mod AnimalsNaturally -Owner local_<session id> -Label "avec-loadafter <sha>" -DepMap wsl-deps.avec-loadafter.map `
  -Filter 'Animals Naturally - Pickle tests,!01-baseline' -EvidenceDir AnimalsNaturally/Tests/Pickle/Evidence/avec-loadafter
```

A request carries no SHA: the mod is staged when its ticket is played, from the working tree of that moment. Keep `Mod/` on the
revision to test until `RUN_DONE`, and put the SHA in the label.

## What is asserted, and what cannot be

Every patch of the mod is an XPath conditional on a def, so the honest questions for a running game are: does it load, does it reach
the defs it targets, and is it silent where its target is absent. The attribution step (`def "X" was patched by mod "M"`) answers the
second one: **M is the mod's DISPLAY name**, not its packageId, because Pickle records `runningMod.Name`.

The **value** a def ends up with cannot be read: `def "X" field "..." is "..."` calls Pickle's `RequireAny`, which refuses a name that
two def types share, and every animal ThingDef here shares its name with its PawnKindDef (checked on all 103 patched names that exist in
Core and the DLC: 100 are shared, the other three are not animals). See `../../TESTING.md`, "What Pickle's vocabulary cannot say".
