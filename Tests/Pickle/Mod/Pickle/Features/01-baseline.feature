# The pass WITHOUT the optional mods, staged from no map at all: Core, the DLCs, Harmony, RimLogging,
# Pickle, Nocturnal Animals (the one hard dependency, resolved by ../../../wsl-ids.map), this mod and
# this companion. Nothing else. Run it with `-Filter '01-baseline'` and no `-DepMap`, since the
# scenarios below assert that the optional mods are ABSENT.
#
# What only a running game can show for this mod, and what these scenarios can and cannot say:
#   - every patch of the mod is an XPath conditional on the def existing, so with no animal mod in the
#     list nearly all of the ten files find nothing. What must hold then is that they load, patch what
#     vanilla offers, and say nothing;
#   - "def X was patched by mod M" is Pickle's own attribution: it records the operations whose XPath
#     matched a def in the unified document just before the patches ran, and keeps only those that
#     succeeded. It is read by DISPLAY NAME (the running mod's Name), not by packageId, so this file
#     spells "Nelim's Animals, Naturally". It proves a patch reached a def; it does not read the value
#     the def ended up with. See TESTING.md, "What Pickle's vocabulary cannot say": `def "X" field "..."
#     is` refuses every animal here, because each animal ThingDef shares its name with its PawnKindDef.
#
# To read the attribution as a proof of one family, each def below is one that a single patch file
# targets among the vanilla defs (checked against the shipped patches on 2026-09-28):
#   Rythme.xml only:       Alphabeaver, Boomrat, Megascarab
#   Regles.xml only:       Warg
#   Hybridation.xml only:  Thrumbo
# The five numeric files (BodySize, Croissance, Lifespan, Productivite, Reproduction) have no such def:
# every vanilla animal they touch is touched by several of them, so one name cannot tell them apart.
Feature: Nelim's Animals, Naturally with only its required dependency

  Scenario: it loads after Nocturnal Animals, its one hard dependency
    Then mod "nelim.animalrebalance" is loaded
    And mod "Mlie.XNDNocturnalAnimals" is loaded
    And mod "nelim.animalrebalance" loads after "Mlie.XNDNocturnalAnimals"

  Scenario: no optional mod is in this pass
    # Without this, a green "with nothing extra" could be an accident of staging. The Alpha Animals
    # def is the second witness: it exists only in the pass that stages that mod.
    Then mod "Mlie.DogsMate" is not loaded
    And mod "Mlie.SomeLikeItRotten" is not loaded
    And mod "com.abobashark.zoologymod" is not loaded
    And mod "OskarPotocki.VanillaFactionsExpanded.Core" is not loaded
    And mod "Mlie.AnimalsForage" is not loaded
    And no def "AA_AnimusVox" exists

  Scenario: the vanilla animals survive the load
    # Rythme.xml writes a Nocturnal Animals DefModExtension. Without that mod's class the game drops
    # the whole def, and the 2026-09-10 note in Rythme.xml records 47 vanilla animals lost that way,
    # Muffalo included. Both databases are read: a def that vanished from one would still be found
    # by a plain `exists`.
    Then def "Muffalo" of type "ThingDef" exists
    And def "Muffalo" of type "PawnKindDef" exists
    And def "Horse" of type "ThingDef" exists
    And def "Horse" of type "PawnKindDef" exists
    And def "Alphabeaver" of type "ThingDef" exists

  Scenario: the circadian rhythm reaches vanilla animals through the Nocturnal Animals extension
    # Rythme.xml is one PatchOperationFindMod on the NAME "[XND] Nocturnal Animals (Continued)". These
    # three ThingDefs are targeted by that file alone, so the attribution can only come from it: the
    # FindMod matched and its sequence ran. Muffalo is targeted by Rythme.xml and Hybridation.xml.
    Then def "Alphabeaver" was patched by mod "Nelim's Animals, Naturally"
    And def "Boomrat" was patched by mod "Nelim's Animals, Naturally"
    And def "Megascarab" was patched by mod "Nelim's Animals, Naturally"
    And def "Muffalo" was patched by mod "Nelim's Animals, Naturally"

  Scenario: the hard rules reach a vanilla animal
    # Regles.xml alone targets Warg (retaliation, taming failure, maximum prey size).
    Then def "Warg" was patched by mod "Nelim's Animals, Naturally"

  Scenario: the hybridisation groups reach a vanilla animal
    # Hybridation.xml alone targets Thrumbo. The value is a list of defs: no step reads a list.
    Then def "Thrumbo" was patched by mod "Nelim's Animals, Naturally"

  Scenario: the numeric families reach vanilla animals
    # BodySize, Croissance, Lifespan, Productivite and Reproduction: several files per def, so this
    # says "some patch of this mod reached it", not which one and not the resulting value.
    Then def "Horse" was patched by mod "Nelim's Animals, Naturally"
    And def "Cow" was patched by mod "Nelim's Animals, Naturally"
    And def "Bear_Grizzly" was patched by mod "Nelim's Animals, Naturally"
    And def "Chicken" was patched by mod "Nelim's Animals, Naturally"

  Scenario: a patch whose target mod is absent does nothing, quietly
    # Every entry naming an animal of an absent mod is a conditional on that def existing. None of
    # these defs exists in this pass, so nothing may have patched them; the warnings of this mod are
    # read by DISPLAY NAME because that is what RimLogging stores (see TechLevelFixes 01-alone).
    Then no def "AA_AnimusVox" exists
    And no def "AA_AnimusVox" was patched
    And no def "AEXP_Beagle" exists
    And no def "AEXP_Beagle" was patched
    And no def "SCBorderCollie" exists
    And no def "SCBorderCollie" was patched
    And no def "ZDuck_Cayuga" exists
    And no def "ZDuck_Cayuga" was patched
    And no warnings from mod "Nelim's Animals, Naturally"

  Scenario: the forage complement is off without Vanilla Expanded Framework
    # Forage.xml is a single PatchOperationFindMod on "Vanilla Expanded Framework". RawBerries is a
    # Core item that only Forage.xml targets, and only as a guard inside that FindMod, so it can be
    # attributed only if the FindMod matched. Here it must not be.
    Then def "RawBerries" exists
    And no def "RawBerries" was patched

  Scenario: the load logs no error
    # A separate scenario on purpose. Read Hybridation.xml before trusting a red here: it writes
    # canCrossBreedWith lists that name defs of mods that may be absent (Duck lists ZDuck_*), with no
    # guard on those names. A cross-reference to a missing def is logged as an error by the game. If
    # this scenario is red, read the message first: that is the suspected defect, not a test fault.
    # Unverified when written (2026-09-28): see TESTING.md.
    Then no errors were logged
