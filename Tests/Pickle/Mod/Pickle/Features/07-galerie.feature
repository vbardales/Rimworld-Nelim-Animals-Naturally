# Workshop gallery pictures, a staged series (owner's rule, 2026-10-02: the gallery is promotional, nothing is left at
# the generated defaults, only menus are plain screenshots). They assert almost nothing about the mod (01 and 06 do):
# a green run says the trip happened, not that a picture shows anything. Open every picture before keeping it.
#
# THE NATURALIST'S PLATE. A field station on the flower meadow of the shared studio (nelim-zen-meadow-studio, patch
# near (154, 98)): the same ground for the whole series, a standing lamp on one side, a potted plant and a small shelf
# on the other. Image 1: the animals in a row by size, mouse to elephant, as on a field-guide plate. Image 2: a
# menu (the Health tab of a horse), taken as it is. Image 3: a grizzly, hungry, with berry bushes around. The set is
# placed, photographed, removed, then the next picture.
#
# Zoom rule (owner, 2026-10-02): the subject fills at least 50 percent of the screen height OR width. Each frame step
# asks for 60 percent of the rectangle that holds the subject. Whether it did is read on the picture.
#
# Run it with `-DepMap wsl-deps.galerie.map -Filter '07-galerie'`. English only: the mod shows no text.
@requires:OskarPotocki.VanillaFactionsExpanded.Core @requires:nelim.pickletools.stagedecor @review @en-only
Feature: Gallery pictures of Nelim's Animals, Naturally

  Background:
    Given the save "nelim-zen-meadow-studio" is loaded
    And game speed is paused
    And I set the hour to 10
    And I set the weather to "Clear"

  Scenario: image 1, the plate: six animals by size on the meadow
    Given Nelim's Pickle Tools: 1 adult animals of kind "Rat" are spawned around (146, 98)
    And Nelim's Pickle Tools: 1 adult animals of kind "Fox_Red" are spawned around (150, 98)
    And Nelim's Pickle Tools: 1 adult animals of kind "Wolf_Timber" are spawned around (154, 98)
    And Nelim's Pickle Tools: 1 adult animals of kind "Horse" are spawned around (158, 98)
    And Nelim's Pickle Tools: 1 adult animals of kind "Bear_Grizzly" are spawned around (162, 98)
    And Nelim's Pickle Tools: 1 adult animals of kind "Elephant" are spawned around (167, 98)
    And Nelim's Pickle Tools: I place the decor "StandingLamp" at (143, 100)
    And Nelim's Pickle Tools: I place the decor "PlantPot" at (170, 100)
    And Nelim's Pickle Tools: I place the decor "ShelfSmall" at (172, 97)
    When Nelim's Pickle Tools: I frame the cells (143, 95) to (171, 101) filling 60 percent of the screen
    Then Nelim's Pickle Tools: the framed cells fill at least 50 percent of the screen
    And Nelim's Pickle Tools: studio presentation mode is enabled
    And I take a screenshot "gallery 1 plate"
    And Nelim's Pickle Tools: the decor is removed
    Then no errors were logged

  Scenario: image 2, the Health tab of a horse (a menu, not staged)
    Given Nelim's Pickle Tools: 1 adult animals of kind "Horse" are spawned around (154, 98)
    When I select "coat-1"
    And Nelim's Pickle Tools: I open the "Health" inspect tab
    Then Nelim's Pickle Tools: the "Health" inspect tab is open
    When I take a screenshot "gallery 2 horse health"
    Then no errors were logged

  Scenario: image 3, a hungry grizzly digs for berries
    Given Nelim's Pickle Tools: 1 adult animals of kind "Bear_Grizzly" are spawned around (154, 98)
    And Nelim's Pickle Tools: the animals of kind "Bear_Grizzly" have food at 0 percent
    And Nelim's Pickle Tools: I place the decor "Plant_Berry" at (150, 99)
    And Nelim's Pickle Tools: I place the decor "Plant_Berry" at (158, 99)
    And Nelim's Pickle Tools: I place the decor "StandingLamp" at (147, 100)
    When I wait 900 ticks
    And Nelim's Pickle Tools: I frame the cells (148, 96) to (160, 101) filling 60 percent of the screen
    Then Nelim's Pickle Tools: the framed cells fill at least 50 percent of the screen
    When Nelim's Pickle Tools: studio presentation mode is enabled
    And I take a screenshot "gallery 3 grizzly forage"
    And Nelim's Pickle Tools: the decor is removed
    Then no errors were logged
