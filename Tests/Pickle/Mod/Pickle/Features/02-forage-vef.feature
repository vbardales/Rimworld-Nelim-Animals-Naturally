# The pass "avec-vef", staged from wsl-deps.avec-vef.map: Vanilla Expanded Framework, Alpha Animals,
# Vanilla Animals Expanded and Animals Forage (Continued). Forage.xml is a single PatchOperationFindMod
# on the name "Vanilla Expanded Framework"; its entries add VEF's CompProperties_DigWhenHungry and
# CompProperties_DigPeriodically to animals that Animals Forage (Continued) does not cover.
#
# Run it with `-DepMap wsl-deps.avec-vef.map -Filter 'Animals Naturally - Pickle tests,!01-baseline,!07-galerie'`.
# In the bare pass the @requires tag skips this whole file and the report counts it as skipped: that is
# not a pass, see TESTING.md.
#
# Attribution again (see 01-baseline): "was patched by mod" is read by DISPLAY NAME and only the
# operations that succeeded are kept. Each Forage.xml entry is, in order: the animal exists (always
# succeeds), the item to dig exists, the animal is not a carnivore, then the comp is added.
@requires:OskarPotocki.VanillaFactionsExpanded.Core
Feature: Nelim's Animals, Naturally with Vanilla Expanded Framework and the animal packs

  Scenario: the pass carries what the forage complement acts on
    Then mod "OskarPotocki.VanillaFactionsExpanded.Core" is loaded
    And mod "sarg.alphaanimals" is loaded
    And mod "VanillaExpanded.VanillaAnimalsExpanded" is loaded
    And mod "Mlie.AnimalsForage" is loaded
    And mod "nelim.animalsnaturally" is loaded
    And mod "nelim.animalsnaturally" loads after "OskarPotocki.VanillaFactionsExpanded.Core"

  Scenario: the complement applies to a vanilla animal digging a vanilla item
    # Bear_Grizzly -> RawBerries. RawBerries is a Core item that only Forage.xml targets, and only
    # inside the FindMod: its attribution is the proof that the guard matched and the entry ran.
    Then def "RawBerries" was patched by mod "Nelim's Animals, Naturally"
    And def "Bear_Grizzly" was patched by mod "Nelim's Animals, Naturally"

  Scenario: the complement applies to an item that another mod defines
    # Forage.xml has 26 entries digging AEXP_RawFish, an item that Animals Forage (Continued) defines
    # (found in its Items_Resource_Misc.xml on 2026-09-28). The item must exist for the entry to
    # fire, so its attribution shows the entries reached a def that only this pass stages.
    Then def "AEXP_RawFish" exists
    And def "AEXP_RawFish" was patched by mod "Nelim's Animals, Naturally"

  Scenario: the complement reaches an Alpha Animals animal
    # Alpha Animals defines AA_CrystallineCaracal as a ThingDef and as a PawnKindDef, hence the typed
    # existence step. The outer operation of a Forage entry always succeeds, so this attribution
    # proves the entry was READ for that animal, not that its comp was added: the item scenarios
    # above and below carry that.
    Then def "AA_CrystallineCaracal" of type "ThingDef" exists
    And def "AA_CrystallineCaracal" was patched by mod "Nelim's Animals, Naturally"

  Scenario: the complement's meat entries find their item
    # 42 of the 91 entries of Forage.xml guard on Meat_Rat or Meat_Megaspider (32 and 10). The guard
    # only tests that the meat def exists at patch time; the mod patches the ANIMAL, never the meat
    # def. So the check is on one animal per guard: AA_CrystallineCaracal (Meat_Rat, already proven by
    # the scenario above) and VAERoy_Pheasant (Meat_Megaspider, from Vanilla Animals Expanded - Royal Animals, 2858079457,
    # staged by this pass since 2026-10-02). Run e85c (2026-09-28) showed the earlier "Meat_Rat was patched"
    # assertion was a test fault: the mod never patches Meat_Rat. Run 1cf2 (2026-09-28) corrected the
    # defName to "ACPHedgehog" (Forage.xml's own xpath target), but run avec-vef-r5 (2026-09-29) showed
    # ACPHedgehog does not exist in this pass: its owning mod (Animal Collab Project) is not staged
    # here (closest matches: AEXP_Hedgehog, from the pack this pass DOES stage). Switched to
    # AEXP_Pangolin, but run avec-vef-slow (2026-10-02) showed that one does not exist either (closest:
    # AEXP_Kangaroo, AEXP_CatSomali, AEXP_Lion). Ten Meat_Megaspider-guarded names exist in Forage.xml;
    # only VAERoy_Pheasant has a pack that is cheap to stage (needs VEF and Royalty, both present).
    Then def "VAERoy_Pheasant" of type "ThingDef" exists
    And def "VAERoy_Pheasant" was patched by mod "Nelim's Animals, Naturally"

  Scenario: the animal packs add no warning of this mod
    Then no warnings from mod "Nelim's Animals, Naturally"

  Scenario: the load logs no error
    # Ambient errors of the other mods in this pass are possible: if red, read which mod logs it
    # before concluding anything about this one.
    Then no errors were logged
