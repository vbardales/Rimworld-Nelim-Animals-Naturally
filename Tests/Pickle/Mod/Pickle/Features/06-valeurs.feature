# Pass "valeurs": the bare pass plus the DefFields companion of PickleTools (wsl-deps.valeurs.map).
# The companion is opt-in, so the bare pass does not carry it and this file is skipped there.
# Values are the ones the patches write literally: BodySize.xml and Reproduction.xml for Horse, Lifespan.xml, Reproduction.xml and Regles.xml for the second scenario. The type
# is named because Horse is both a ThingDef and a PawnKindDef.
@requires:nelim.pickletools.deffields
Feature: Nelim's Animals, Naturally writes its values

  Scenario: the numeric families write their values on a vanilla animal
    Then Nelim's Pickle Tools: def "Horse" of type "ThingDef" field "race.baseBodySize" is "1.926"
    And Nelim's Pickle Tools: def "Horse" of type "ThingDef" field "race.gestationPeriodDays" is "24.17"

  Scenario: the lifespan, litter and prey-size families write their values on vanilla animals
    # Lifespan.xml, Reproduction.xml and Regles.xml, read from the shipped patches on 2026-10-10.
    # The sentinel 99999 (apex predators) is not asserted here: the mod writes no such value, and the
    # offline Tests/Test-Xml.ps1 checks that no patch file contains it.
    Then Nelim's Pickle Tools: def "Chicken" of type "ThingDef" field "race.lifeExpectancy" is "7.2"
    And Nelim's Pickle Tools: def "Cow" of type "ThingDef" field "race.lifeExpectancy" is "30.6"
    And Nelim's Pickle Tools: def "Cow" of type "ThingDef" field "race.gestationPeriodDays" is "25.35"
    And Nelim's Pickle Tools: def "Warg" of type "ThingDef" field "race.maxPreyBodySize" is "1.4"
