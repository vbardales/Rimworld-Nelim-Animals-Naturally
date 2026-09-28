# Testing and evidence retention

Not shipped: it lives beside `Mod/`, never inside it, so Steam never receives it.

## Current status (2026-09-28)

- **Written**: a Pickle suite, `Tests/Pickle/`, of five features and 22 scenarios. None is tagged `@wip`. It uses only steps
  that exist in Pickle's own vocabulary; nothing is compiled.
- **Run**: nothing has been played on any revision. The three passes below were filed as requests on 2026-09-28
  (`STATUS.md` gives their ids and state); until a report exists for each, every scenario is unverified, not passed.
- **Not written**: offline XML patch-application tests (see "What is not covered"), so no value the mod writes is checked anywhere yet.
- **Manual tests**: none recorded, none pending. Each behaviour is either a scenario below or listed as not covered.

`@wip` is absent because nothing was set aside, not because everything passed.

## What the mod is, and what that leaves to test

`Mod/` holds `About/` and ten files under `Patches/`, and nothing else: no assembly, no `Defs`, no `Languages`, no settings, no
player-facing text. Every patch writes a number, a list or a `DefModExtension` on a def that another mod (or the base game) defines,
under an XPath conditional on that def existing. So a running game can be asked three things: does it load, does it reach the defs it
targets, and is it silent where its target mod is absent.

| Patch file | Writes | Guard | Target mods | In a scenario |
|---|---|---|---|---|
| `Rythme.xml` | a Nocturnal Animals `bodyClock` extension | `PatchOperationFindMod` on the names of Nocturnal Animals, which is a **hard dependency** | vanilla and many animal packs | `01-baseline`: Alphabeaver, Boomrat, Megascarab (Rythme only), Muffalo |
| `Regles.xml` | `maxPreyBodySize`, `manhunterOnDamageChance`, `roamMtbDays` | def exists | vanilla and packs | `01-baseline`: Warg (Regles only) |
| `Hybridation.xml` | `race/canCrossBreedWith` lists | def exists | vanilla and packs | `01-baseline`: Thrumbo (Hybridation only) |
| `BodySize.xml`, `Croissance.xml`, `Lifespan.xml`, `Productivite.xml`, `Reproduction.xml` | `baseBodySize`, last life stage `minAge`, `lifeExpectancy`, comps, gestation/mate/litter | def exists | vanilla and packs | `01-baseline`: Horse, Cow, Bear_Grizzly, Chicken (attribution by name: several files each) |
| `Doublons.xml` | removes `wildBiomes` and biome entries of duplicate species | def exists | only animal packs (no vanilla def) | `01-baseline`: inert when the packs are absent. Applies nowhere in a scenario: see "What is not covered" |
| `Forage.xml` | VEF `CompProperties_DigWhenHungry` / `DigPeriodically` | `PatchOperationFindMod` on **Vanilla Expanded Framework** | vanilla, Alpha Animals, Vanilla Animals Expanded | `01-baseline`: off without VEF. `02-forage-vef`: on with VEF |
| (`<loadAfter>`) | none | none | Dogs Mate, Some Like It Rotten, Zoology | `03`, `04`, `05`: the mod loads below each, and is silent |

`Mlie.DogsMate`, `Mlie.SomeLikeItRotten` and `com.abobashark.zoologymod` are in `<loadAfter>` only. **No XPath of the mod targets any
of them** (checked 2026-09-28 across the ten files): `About.xml` says Hybridation "patches Dogs Mate AnimalGroupDefs", but
`Hybridation.xml` writes the vanilla `canCrossBreedWith` field. Their scenarios therefore assert the load, not a patch.

## How many passes, and what each covers

`AUDIT.md`: a mod is validated over at least two passes, one without the optional mods and one with them, the report saying which is which.

| Pass | Request | Stages | What it proves |
|---|---|---|---|
| **sans-facultatifs** | `-Filter '01-baseline'`, no `-DepMap` | Core, the DLCs, Harmony, RimLogging, Pickle, Nocturnal Animals (`wsl-ids.map`), the mod, the companion | The mod stands with its one hard dependency: the vanilla animals survive, Rythme, Regles and Hybridation reach vanilla defs, the patches of absent mods stay silent, the forage complement is off |
| **avec-vef** | `-DepMap wsl-deps.avec-vef.map -Filter 'Animals Naturally - Pickle tests,!01-baseline'` | the above plus VEF, Alpha Animals, Vanilla Animals Expanded, Animals Forage (Continued) | The forage complement is on, reaches vanilla and pack defs, and the mod is silent beside the packs |
| **avec-loadafter** | `-DepMap wsl-deps.avec-loadafter.map -Filter 'Animals Naturally - Pickle tests,!01-baseline'` | the first plus Dogs Mate, Some Like It Rotten, Zoology | The mod loads below the three `loadAfter` mods, silent, and still reaches vanilla defs beside Zoology |

The two optional passes are separate so that a red is attributable: VEF and the animal packs on one side, three mods that do not
touch this mod's XPaths on the other. The mods were not proven to coexist in a single list, and nothing here claims they do.
The conditional features carry `@requires:<packageId>`: in the bare pass they are **skipped**, and a skipped scenario is not a passed one.

**Not applicable, with the reason** (`AUDIT.md`, "On ne teste pas le jeu"; `Authoring/README.md` section 3):

- *Incompatibility pass*: `About.xml` declares no `incompatibleWith`.
- *DLC-absent pass*: no DLC is declared and no patch is guarded on one. `Warg` and `Alphabeaver` are Core; Odyssey and Biotech defs are patched
  only when present, by the same conditional as any other def.
- *English and French passes*: the mod adds no player-facing text and has no `Languages/` folder, so there is nothing to display in either.
- *Removing a patch file, removing the mod, save and reload*: the game's handling of an absent file or mod is the game's. The mod
  stores nothing (no assembly, no saved data) and defines no def that a save could reference, so a save does not depend on it beyond the
  values of defs the game rebuilds at each load.
- *Existing-save behaviour*: same reason. A change of `lifeExpectancy`, `baseBodySize` or gestation applies to living animals through the
  def, at the next load; that is vanilla arithmetic on the def, not a state the mod keeps.

## What Pickle's vocabulary cannot say

Read from Pickle 4.x on 2026-09-28 (`RimWorks.Pickle.Vanilla.dll`, `DefSteps` and `DefLookup`, decompiled).

1. **No value can be read.** `def {string} field {string} is {string}` (and `stat`, `raw stat`, `costs`, `is defined by mod`) resolve the
   name with `RequireAny`, which throws when the name is shared by two def types. Every animal ThingDef patched here shares its name with
   its PawnKindDef: 100 of the 103 patched names that exist in Core and the DLC are defined twice, and the other three (`Neanderthal`,
   `RawBerries`, `RawFungus`) are not animal ThingDefs. The typed form `def "X" of type "T"` exists only for `exists`. So the baseline
   values (Horse `baseBodySize` 1.926, Cow `lifeExpectancy` 30.6, and so on for the 1,960 scalar writes of BodySize, Lifespan, Regles, Reproduction and Croissance, counted on 2026-09-28) are **asserted nowhere**.
2. **No list can be read** (`canCrossBreedWith`, `lifeStageAges`), and no path syntax reaches a list element.
3. **No `DefModExtension` can be read** (`bodyClock`). `TeshiSteps` in CreaturesOfKiRenew reads the extension with a local C# step; it is prefixed
   for that mod and is not shared.
4. **Attribution is by def name, not by file**, and it records an operation that matched and succeeded. A def targeted by several patch files
   cannot be tied to one of them: only Rythme (Alphabeaver, Boomrat, Megascarab), Regles (Warg), Hybridation (Thrumbo) and Forage (through its
   item guard, RawBerries) have a discriminating vanilla def. BodySize, Croissance, Lifespan, Productivite and Reproduction have none.
5. The attribution is read by the mod's **display name**, "Nelim's Animals, Naturally", not its packageId. `no warnings from mod` reads the
   same display name.

Closing 1 to 3 needs either a step upstream (`def "X" of type "T" field "..." is "..."`; nothing about it is in `PickleTools/Upstream/PENDING.md`,
and nothing goes to Pickle without Virginie's agreement) or a local C# step assembly in the companion. Neither was built: the brief for this
suite was to use the existing vocabulary and record the gap.

## Suspected defects the suite is written to expose

Both come from reading the patches and the game's loader, **not from a run**. They are hypotheses until a report says otherwise.

- **`Hybridation.xml` lists defs of absent mods** (`race/canCrossBreedWith`, for example Duck listing `ZDuck_Bufflehead`). The guard is on the
  animal, not on the names in its list, and a list entry that names a missing def is normally logged as an error by the game. If so,
  `01-baseline` "the load logs no error" is red in the bare pass, and `About.xml`'s "All patches are conditional... without load errors"
  is untrue. The scenario is kept apart so that its red reads alone.
- **`Forage.xml` guards 42 of its 91 entries on `Meat_Rat` or `Meat_Megaspider`** (32 and 10). Neither name is defined in Core, the DLCs or any
  of the mods searched (one search over 9,051 folders on 2026-09-28): they are the meat defs the game generates from races after patching.
  If so, those entries can never fire. `02-forage-vef` "the complement's meat entries find their item" is red in that case.

## Requirements before `tested`

- Every conditional scenario has run on the delivered revision, with the modlist that enables it, and its report was read (`setName`, suite and
  scenario names, `exitReason`, discovered against played) before being cited: the report folder is shared by the whole machine.
- No scenario is tagged `@wip`.
- Every `@requires`-skipped scenario of the bare pass has its own pass where it ran.
- Each item under "What is not covered" is closed, or explicitly accepted by Virginie as not applicable.
- No manual check is left to validate. There is none recorded.

## What is not covered

- **The values the patches write** (point 1 above). Closing this is `pending` work: either the upstream step or a local step, or, following
  `TechLevelFixes/Tests/`, an offline test that applies the shipped patch operations to a synthetic document in a console process (no game,
  seconds, and it would settle every numeric family). `AUDIT.md` prefers the offline route for exactly this, and asks for "Tests XML écrits,
  exécutés et au vert" before `done`.
- **`Doublons.xml` applying.** It targets only animal-pack defs and `BiomeDef` entries, in packs the passes do not stage (SCWelshCorgi and WD_Corgi among them). No scenario shows one of its removals firing.
- **The animal packs beyond Alpha Animals and Vanilla Animals Expanded.** Dozens of other packs are targeted (their defName prefixes
  include SC, WD, CK, ERN, HC, BB, BU, TYR, VAERoy, ZDuck...). None is staged. Whether they can all coexist
  in one list has not been measured, and nothing here implies they can.
- **A pass with Nocturnal Animals absent.** It is a hard dependency; the game's reaction to a missing hard dependency is the game's.

## Evidence to keep locally

Evidence remains on disk and is ignored by Git (`Tests/Pickle/Evidence/`, `evidence/`). Before deleting anything, list the files that will go
and the files that remain; repoint `STATUS.md` first if it names a file.

For each scenario and exact revision, keep only the newest terminal report that proves the current check: `summary.json`, `junit.xml`, and
only the `@review` screenshots needed to show the claimed visual result (this suite has none). Keep an older report only when it is the sole
proof of a check not repeated by the newer run. Do not retain superseded `report.html`, `messages.ndjson`, complete shared Pickle archives, or
`Player.log` unless one is the sole evidence of a failure diagnosis. The launcher's archives in `pickle-reports-archive/` are full copies of the
shared report folder and are not trimmed by it: after a run, select what this mod needs from the archive of its own run, then delete that archive
and leave the others alone (`keep.txt` marks one held for review). Summarise every run as one text line in `docs/runs/history.md`, never as a
folder.

## 2026-09-28 retention decision

- Delete: nothing. No `Tests/Pickle/Evidence/`, `evidence/` or `.dds` file exists in this checkout, and none is tracked by Git.
- Keep: nothing. No run has produced a report for this mod yet.

## Update 2026-09-28

The typed value step exists in PickleTools/docs/steps.md: `def {string} of type {string} field {string} is {string}`. Gap 1 above is closed for ThingDef/PawnKindDef values; 01-baseline now reads Horse race.baseBodySize and race.gestationPeriodDays. The Meat_Rat suspicion is refuted: the guard tests existence at patch time and AA_CrystallineCaracal was patched in run e85c. The failed avec-vef scenario asserted a patch on Meat_Rat, which this mod never makes: a test fault, corrected.

The typed step lives in PickleTools' opt-in companion DefFields (`nelim.pickletools.deffields`, path `PickleTools/DefFieldSteps/Mod`), so it needs a pass of its own: `wsl-deps.valeurs.map` plus `06-valeurs.feature` (tag `@requires:nelim.pickletools.deffields`). The bare pass skips it. The companion has never run in a game yet: a value read that differs from the patch value is reported to PickleTools with def, path and actual.

## Update 2026-09-28 (run 1cf2/avec-vef-r2)

`1cf2` was submitted without `-Filter`, so it played the whole suite (23 scenarios) under the avec-vef modlist instead of only `02-forage-vef.feature` (12 scenarios). The three extra failures ("no optional mod is in this pass", "a patch whose target mod is absent does nothing, quietly", "the forage complement is off without Vanilla Expanded Framework") are 01-baseline scenarios that assert the bare-pass condition; they correctly fail when optional mods are present. Not a mod defect, not a test defect: a submission mistake, corrected by adding `-Filter 02-forage-vef` on resubmission.

The fourth failure was real: the meat-entries scenario named `Herisson` as the ThingDef for the Meat_Megaspider guard. The actual defName in Forage.xml is `ACPHedgehog` ("Herisson" is only the mod's French comment). Corrected in 02-forage-vef.feature.

## Update 2026-09-28 (run 1899/rotten stall) and upstream remotes

Bisecting `avec-loadafter` (72fd, stalled): Dogs Mate alone (574d) is clean, 1/1 passed. Some Like It Rotten alone (1899) reproduces the exact same stall (exit 3, 42-line Player.log, staging correct: 13 mods including brrainz.harmony). This is a defect of Some Like It Rotten's own startup under this environment, not of this mod: the mod's patches never target it, only `<loadAfter>` in About.xml. Zoology alone (6e7f) still pending. Until this is resolved upstream or worked around, `03-dogsmate.feature` and `05-zoology.feature` (both filed under the same `avec-loadafter` staging as `04-rotten.feature`) cannot run in a single combined pass with Some Like It Rotten present; each needs its own pass map (already the case: `wsl-deps.dogsmate.map`, `wsl-deps.rotten.map`, `wsl-deps.zoology.map`).

Source-mod remotes checked in each mod's own `About.xml` (2026-09-28), recorded in STATUS.md `upstream_mod_remotes`: Nocturnal Animals, Dogs Mate, Some Like It Rotten and Animals Forage are emipa606/* on GitHub; Alpha Animals and Vanilla Animals Expanded link only to the shared Vanilla-Expanded/VanillaExpandedFramework repo, which also has its own entry; Zoology has no GitHub link in its About.xml.

## Update 2026-09-28/29: valeurs pass green, Zoology also stalls

Run fd90 (pass "valeurs", DefFields companion, no `-Filter`): 11 passed, 0 failed, 12 skipped by `@requires` design. The typed step `def "Horse" of type "ThingDef" field "race.baseBodySize" is "1.926"` (and `gestationPeriodDays` "24.17") passed: the DefFields companion works in a real game run, its first ever. Gap 1 from the earlier update is closed for this mod.

Run 6e7f (pass "zoology" alone): stalls at the exact same startup point as 1899 (Some Like It Rotten alone) — exit 3, no report, no error, 42-line Player.log identical in shape. Only Dogs Mate (574d) loads cleanly. Both stalling mods ship their own compiled Assemblies and load after Harmony without error before the stall, so this is not conclusively a code defect from static inspection; a corrupted or incomplete Workshop download of these two specific mods on this machine is a plausible cause, and only Steam-side verification (resubscribe/verify files) can rule it in or out. `03-dogsmate.feature` has run; `04-rotten.feature` and `05-zoology.feature` cannot run until this is fixed. Run 4031 (avec-vef, corrected `-Filter`) is still queued.
