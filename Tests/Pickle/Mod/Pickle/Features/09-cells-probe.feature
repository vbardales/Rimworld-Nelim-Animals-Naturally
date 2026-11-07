# Probe, to delete once read (2026-11-07, second pass): the first probe (run 9958) showed the flower-garden area (146..162, 105..116) holds
# 18 free standable cells, none at the cells of scene 4. This one lists a wider rectangle around it. Read the [free-cells] lines of Player.log.
#   Submit-PickleRun.ps1 -Mod AnimalsNaturally -DepMap wsl-deps.galerie.map -Filter '09-cells-probe' -EvidenceDir Tests/Pickle/Inbox/cells-probe-3
@requires:nelim.pickletools.stagedecor @review @en-only
Feature: Free cells of the flower garden

  Background:
    Given the save "Nelims-tribe" is loaded
    And game speed is paused
    And I set the hour to 10
    And I set the weather to "Clear"
    And Nelim's Pickle Tools: all animals are removed

  Scenario: probe - flower garden wide
    Given Nelim's Sanctuary: I am at the sanctuary "flower-garden"
    When Nelim's Pickle Tools: the free standable cells of the area from (136, 96) to (176, 126) are listed
    Then no errors were logged
