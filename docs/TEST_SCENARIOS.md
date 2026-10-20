# Functional scenarios: Nelim's Animals, Naturally

Not shipped: lives beside `Mod/`, never inside. Written 2026-10-10 against revision `7b3f83a`.

`PUBLICATION.md` has no Steam description block yet, so behaviours below = ones promised by `Mod/About/About.xml`
(`<description>`) plus two patch families it does not list (`Rythme.xml`, `Forage.xml`). One scenario per promised behaviour.
Figures read from shipped patch files 2026-10-10 (see "Figures checked"). `TESTING.md` holds pass map and run history; this file holds what each behaviour must do.

Mod is XML only: no assembly, no `Defs`, no text, no settings. Scenario asks one of three things: does patch reach target, does it write stated value, is it silent where target absent.

Legend for **Run by**: `Test-Xml` is `pwsh Tests/Test-Xml.ps1` (offline, no game). `Pickle NN` is feature under
`Tests/Pickle/Mod/Pickle/Features/`. Pickle runs filed as tickets with Ticket Manager, never launched by session.

## Scenarios

### S1. Body size follows the cube root of mass

- **Source**: `BodySize.xml` (promise: "Body size: the cube root of mass relative to a 70 kg human").
- **Preconditions**: Core and Nocturnal Animals only (bare pass).
- **Actions**: read `race.baseBodySize` of Horse after patching.
- **Expected**: Horse `baseBodySize` is `1.926`. Def of absent animal pack (Macaw, `0.243`) untouched when pack absent.
- **Run by**: `Test-Xml` (bare fixture); `Pickle 06-valeurs` (`def "Horse" of type "ThingDef" field "race.baseBodySize" is "1.926"`).

### S2. Lifespan follows allometric laws by clade

- **Source**: `Lifespan.xml`, `Croissance.xml` (promise: "Lifespan: allometric laws calibrated by clade").
- **Preconditions**: bare pass.
- **Actions**: read `race.lifeExpectancy` of Chicken and Cow; read last `lifeStageAges` `minAge` of Chicken.
- **Expected**: Chicken `7.2`, Cow `30.6`. Chicken adult `minAge` `0.501`. Chicken lives far shorter than animal-pack parrot (BB_Cockatoo `52.1`).
- **Run by**: `Test-Xml` (Chicken 7.2, Cow 30.6, Cow gestation 25.35); `Pickle 06-valeurs` second scenario (same values, played green 2026-10-10, ticket 8ee7); `Pickle 01-baseline` "the numeric families reach vanilla animals" (attribution only).

### S3. Retaliation: manhunter chance on damage

- **Source**: `Regles.xml` (promise: "retaliation is at least as likely as taming failure").
- **Preconditions**: bare pass, then animal pack defining target (for example Alpha Animals, `AA_BoulderMit`, `0.2`).
- **Actions**: read `race.manhunterOnDamageChance`.
- **Expected**: value written by patch; 14 such writes in `Regles.xml`. In bare pass, no vanilla def with that field touched by this family except where patch finds it.
- **Run by**: `Test-Xml` with synthetic `AA_BoulderMit` (no vanilla def carries this patch): `0.2`. `Pickle 01-baseline` "the hard rules reach a vanilla animal" (Warg, attribution only).

### S4. Trainable animals do not escape their pens

- **Source**: `Regles.xml` (promise: "trainable animals do not escape their pens").
- **Mechanism**: patch **removes** `race/roamMtbDays` (60 `PatchOperationRemove` in `Regles.xml`, for example `AA_IronhuskBeetle`); sets no value.
- **Expected**: after patching, def has no `roamMtbDays` element; game default (no roaming) applies.
- **Run by**: `Test-Xml` with synthetic `AA_IronhuskBeetle` starting with `roamMtbDays` (no vanilla def carries this patch): element gone after patching. Not testable in Pickle without "field is absent" step.

### S5. Maximum prey size accounts for hunting method; apex predators keep the sentinel

- **Source**: `Regles.xml` (promise: "maximum prey size accounts for hunting method"; "apex predators retain the maxPreyBodySize = 99999 sentinel").
- **Preconditions**: bare pass.
- **Actions**: read Warg `race.maxPreyBodySize`. Count writes of `99999` in `Mod/Patches`.
- **Expected**: Warg `1.4` (186 `maxPreyBodySize` writes in all). **No patch writes `99999`** (0 occurrences 2026-10-10): sentinel retained by *not* patching those defs, so def carrying it in Core or pack keeps it.
- **Run by**: `Test-Xml` (Warg `1.4`; no patch file contains `99999`); `Pickle 06-valeurs` second scenario (Warg `1.4`, played green 2026-10-10, ticket 8ee7).

### S6. Hybridisation groups from real taxonomy

- **Source**: `Hybridation.xml` (promise: "Hybridisation: groups derived from real taxonomy in Dogs Mate format").
- **Preconditions**: bare pass.
- **Actions**: read `race.canCrossBreedWith` of Duck and Thrumbo after patching.
- **Expected**: lists written on vanilla field, symmetric by construction. Duck lists `ZDuck_Bufflehead`, `ZDuck_Cayuga`, `ZDuck_EiderPintail`, `ZDuck_GreaterMallard`, `ZDuck_RudderDuck`; Thrumbo lists `AlphaThrumbo`. Bare pass loads without error although entries name defs of absent mods.
- **Run by**: `Test-Xml` (Duck written unconditionally); `Pickle 01-baseline` "the hybridisation groups reach a vanilla animal" (Thrumbo) and "the load logs no error".

### S7. Circadian rhythm (not in the description, in the code)

- **Source**: `Rythme.xml`, guarded by `PatchOperationFindMod` on display names `[XND] Nocturnal Animals` and `[XND] Nocturnal Animals (Continued)`.
- **Expected**: `Alphabeaver`, `Boomrat`, `Megascarab` get `bodyClock` Nocturnal; Muffalo gets Crepuscular. File totals: 151 Nocturnal, 97 Crepuscular, 1 Cathemeral. Dependency absent → file inert (game would otherwise drop whole defs).
- **Run by**: `Test-Xml` (bare fixture and no-dependency fixture); `Pickle 01-baseline` "the circadian rhythm reaches vanilla animals through the Nocturnal Animals extension".

### S8. Forage complement (not in the description, in the code)

- **Source**: `Forage.xml`, guarded by `PatchOperationFindMod` on Vanilla Expanded Framework; 91 animals; entries guarded on meat or item def existing.
- **Expected**: with VEF, Bear_Grizzly digs RawBerries x10; AA_CrystallineCaracal digs Meat_Rat x5; Meat_Megaspider-guarded animal of staged pack digs Meat_Megaspider x10. Without VEF nothing written.
- **Run by**: `Test-Xml` (VEF fixture); `Pickle 01-baseline` "the forage complement is off without Vanilla Expanded Framework"; `Pickle 02-forage-vef` (needs VEF, Alpha Animals, Vanilla Animals Expanded, Animals Forage, Royal Animals).

### S9. Every patch is conditional: removing an animal mod is silent

- **Source**: `About.xml` ("All patches are conditional: removing an animal mod simply makes its corresponding patches inert, without load errors").
- **Actions**: load with none of animal packs; load with Nocturnal Animals absent.
- **Expected**: no error in log; unrelated defs untouched.
- **Run by**: `Test-Xml` (absent-everything and no-dependency fixtures); `Pickle 01-baseline` "a patch whose target mod is absent does nothing, quietly" and "the load logs no error".

### S10. Duplicate wild species are removed

- **Source**: `Doublons.xml` (one wild copy per species; kept animals stay tameable and breedable).
- **Expected**: for duplicate pair (SCWelshCorgi yields to AEXP_Corgi), `race/wildBiomes` of duplicate and its `BiomeDef/wildAnimals` entry removed.
- **Run by**: `Test-Xml` (synthetic SCWelshCorgi / TemperateForest fixture). No real pack staged in Pickle.

### S11. Load order: after all animal mods

- **Source**: `About.xml` (`<loadAfter>`: Dogs Mate, Nocturnal Animals, Some Like It Rotten, Zoology; "Load AFTER all animal mods").
- **Expected**: mod loads below each and is silent. No XPath targets Dogs Mate, Some Like It Rotten or Zoology; `loadAfter` is ordering only.
- **Run by**: `Test-Xml` (About.xml contract); `Pickle 03-dogsmate`, `04-rotten`, `05-zoology`.

### S12. The precautionary 15 percent rule

- **Source**: `About.xml` ("a value changes only when it differs from its target by more than 15 percent").
- **Status**: **not testable here.** Generator scripts (`scripts/genere_*.ps1`) named in patch headers not in this repository, and shipped patch carries only final value, not vanilla value compared against. No scenario can assert rule from `Mod/`.

## Figures checked (2026-10-10, revision 7b3f83a)

Read from `Mod/Patches/*.xml`: Horse `baseBodySize` 1.926 and `gestationPeriodDays` 24.17; Cow `lifeExpectancy` 30.6 and `gestationPeriodDays` 25.35; Chicken `lifeExpectancy` 7.2; Macaw `baseBodySize` 0.243; Warg `maxPreyBodySize` 1.4;
`roamMtbDays` removals 60; `manhunterOnDamageChance` writes 14; `maxPreyBodySize` writes 186; `bodyClock` 151 / 97 / 1; `99999` occurrences 0.

**Discrepancy to fix in public text, not in code**: `About.xml` says "a macaw lives for 55 years". `Lifespan.xml` has **no entry for `Macaw`**
(Macaw only in `BodySize.xml`, `Croissance.xml`, `Productivite.xml`, `Reproduction.xml`, `Hybridation.xml`). Parrot-family lifespans it does write: `BB_Parrot`, `BB_ParrotB`, `TYR_Parrot_Caica`
and `BB_Cockatoo` (52.1 to 56.6). Chicken figure (7) matches (7.2). "54 species, 7 percent median error" figure comes from generator,
cannot be checked from this repository.

## Gaps (pending work, not defects)

- Added 2026-10-10: assertions above for S2 to S5. Second scenario of `06-valeurs` played green 2026-10-10 (valeurs-r2, 2/2).
- S3 and S4 proven on synthetic pack defs only: no vanilla def carries either patch, so no pass of this suite can read them on real def without staging Alpha Animals with DefFields companion.
- `02-forage-vef` played green on corrected scenario 2026-10-10 (avec-vef-r7, 7/7, `VAERoy_Pheasant` patched). `07-galerie` (gallery, `@review`) played 3/3 on 2026-10-13 (galerie-5); pictures judged by reading, not by run.

## Results on the delivered revision

- 2026-10-10, `7b3f83a` + working tree: `pwsh -NoProfile -File Tests/Test-Xml.ps1` PASS (10 patch files, About.xml contract, bare / no-dependency / VEF fixtures, absent-mod safety, plus S2 to S5 assertions). Negative check: with expected values altered (Chicken 7.3, AA_BoulderMit 0.3, `99999` swapped for string present in files) script reported 4 failures.
- Pickle: see `docs/runs/history.md`. Played green on `Mod/` identical to current except 2026-10-02 `About.xml` THANKS edit: `01-baseline` (sans-facultatifs-r2), `03-dogsmate`, `05-zoology` (zoology-slow2), `06-valeurs` (valeurs), `04-rotten` (rotten-slow2). Also green: `02-forage-vef` (avec-vef-r7, 7/7), `06-valeurs` second scenario (valeurs-r2, 2/2). `07-galerie` is gallery work (`@review`), see `STATUS.md`.
- No manual test remains: new-game and existing-save behaviour accepted as not applicable (Virginie, 2026-10-01, `TESTING.md`).