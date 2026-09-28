# Pass "valeurs": the bare pass plus the DefFields companion of PickleTools (wsl-deps.valeurs.map).
# The companion is opt-in, so the bare pass does not carry it and this file is skipped there.
# Values are the ones the patches write literally: BodySize.xml and Reproduction.xml for Horse. The type
# is named because Horse is both a ThingDef and a PawnKindDef.
@requires:nelim.pickletools.deffields
Feature: Nelim's Animals, Naturally writes its values

  Scenario: the numeric families write their values on a vanilla animal
    Then Nelim's Pickle Tools: def "Horse" of type "ThingDef" field "race.baseBodySize" is "1.926"
    And Nelim's Pickle Tools: def "Horse" of type "ThingDef" field "race.gestationPeriodDays" is "24.17"
