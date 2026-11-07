# Probe, to delete once read (2026-11-07): free standable cells around the places of 07-galerie, so that the cells of its scenarios stop being guesses.
# Reads: the [free-cells] lines of the game log and the "free-cells" attachment of the step (NPT 8e5962e); the lines are read in Player.log of the run.
#   Submit-PickleRun.ps1 -Mod AnimalsNaturally -DepMap wsl-deps.galerie.map -Filter '09-cells-probe' -EvidenceDir Tests/Pickle/Inbox/cells-probe-2
@requires:nelim.pickletools.stagedecor @review @en-only
Feature: Free cells of the gallery places

  Background:
    Given the save "Nelims-tribe" is loaded
    And game speed is paused
    And I set the hour to 10
    And I set the weather to "Clear"
    And Nelim's Pickle Tools: all animals are removed

  Scenario: probe - barn yard
    Given Nelim's Sanctuary: I am at the sanctuary "barn"
    When Nelim's Pickle Tools: the free standable cells of the area from (186, 230) to (208, 240) are listed
    Then no errors were logged

  Scenario: probe - hut
    Given Nelim's Sanctuary: I am at the sanctuary "hut"
    When Nelim's Pickle Tools: the free standable cells of the area from (134, 69) to (146, 77) are listed
    Then no errors were logged

  Scenario: probe - flower garden
    Given Nelim's Sanctuary: I am at the sanctuary "flower-garden"
    When Nelim's Pickle Tools: the free standable cells of the area from (146, 105) to (162, 116) are listed
    Then no errors were logged
