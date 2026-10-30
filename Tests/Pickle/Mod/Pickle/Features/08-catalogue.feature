# Animal catalogue, probe first (owner order 2026-10-30): every animal of every mod, seen from the front, the back and the side, on a bare
# uniform floor, with a registry mod to animal. This file holds the PROBE only: one animal, three views, and the listing of the animal kinds.
#   Submit-PickleRun.ps1 -Mod AnimalsNaturally -DepMap wsl-deps.galerie.map -Filter '08-catalogue' -EvidenceDir Tests/Pickle/Inbox/catalogue-1
# Steps (Nelim's Pickle Tools, commit 8bde807 of PickleTools, compiled, not played at writing): the floor of the area is set to the terrain,
# the animal kinds are listed (log [animal-kind], attachment animal-kinds), the animal stands at a cell facing a direction.
# What the probe must settle: the named spawn is found by the stands-at-facing step in the same scenario; Concrete shows under the animal and
# contrasts with it; the root size of the frame reads at 268 px for a horse (tiers by baseBodySize come after: mouse, dog, elephant).
# A shot is: area emptied, floor set, animal spawned and named, stands at facing, frame, screenshot. Open every picture before keeping it.
@requires:nelim.pickletools.screenshotstudio @requires:nelim.pickletools.colonistrace @review @en-only
Feature: Animal catalogue

  Background:
    Given the save "Nelims-tribe" is loaded
    And game speed is paused
    And I set the hour to 10
    And I set the weather to "Clear"
    And Nelim's Sanctuary: the vanometric cell of the sanctuary is hidden
    And Nelim's Pickle Tools: all animals are removed

  # KINDS. One run lists every animal kind of the loaded game (mod, packageId, kind defName, race defName, label, baseBodySize), read in the log
  # and in the attachment animal-kinds: the registry mod to animal.
  Scenario: kinds - the animal kinds of the loaded game are listed
    Given Nelim's Pickle Tools: the animal kinds are listed
    Then no errors were logged

  # HORSE. Front (South), back (North), side (West), same cell, same frame. enclosure-south, area (146, 208) to (154, 216), animal at (150, 212).
  Scenario: horse - front, back and side on a bare concrete floor
    Given Nelim's Sanctuary: I am at the sanctuary "enclosure-south"
    And Nelim's Pickle Tools: the painted zones are hidden
    And Nelim's Pickle Tools: the area from (146, 208) to (154, 216) is emptied
    And Nelim's Pickle Tools: the floor of the area from (146, 208) to (154, 216) is set to the terrain "Concrete"
    And Nelim's Pickle Tools: an adult animal of kind "Horse" named "horse" is spawned at (150, 212)
    And Nelim's Pickle Tools: the animal "horse" stands at (150, 212) facing South
    And Nelim's Pickle Tools: I frame the area centred on (150, 212) at root size 6
    When Nelim's Pickle Tools: the map is shown alone for a capture
    And I take a screenshot "catalogue-horse-front"
    And Nelim's Pickle Tools: the animal "horse" stands at (150, 212) facing North
    And I take a screenshot "catalogue-horse-back"
    And Nelim's Pickle Tools: the animal "horse" stands at (150, 212) facing West
    And I take a screenshot "catalogue-horse-side"
    And Nelim's Pickle Tools: the interface is shown again
    Then no errors were logged
