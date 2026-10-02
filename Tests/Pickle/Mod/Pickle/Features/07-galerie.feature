# Workshop gallery captures, taken by `@review` scenarios so they can be redone after any change.
# They assert nothing about the mod's values (01 and 06 do): a green run says the trip happened, not that
# an image shows anything. Open every picture before keeping it (PUBLISHING.md, gallery).
#
# Zoom rule (owner, 2026-10-02): the subject fills at least 50 percent of the screen height OR width. The
# framing steps below are a starting point and are corrected by reading the first pictures, not by
# trusting the zoom number; the scene is cropped afterwards, never stretched.
#
# Run it with `-DepMap wsl-deps.galerie.map -Filter '07-galerie'`. English only: the mod shows no text.
@requires:OskarPotocki.VanillaFactionsExpanded.Core @review @en-only
Feature: Gallery captures of Nelim's Animals, Naturally

  Background:
    Given the save "test-colony" is loaded

  Scenario: image 1, the size range, from the mouse to the elephant
    # One adult of each kind, within four cells of the map centre, framed on the horse (mid-size).
    # Biggest first: "close together" needs a clear area around each animal, and run galerie-1 could not place
    # the fifth (a cow) after rat, hare, fox and wolf had taken the room.
    Given Nelim's Pickle Tools: 1 adult animals of kind "Elephant" are spawned close together
    And Nelim's Pickle Tools: 1 adult animals of kind "Bear_Grizzly" are spawned close together
    And Nelim's Pickle Tools: 1 adult animals of kind "Horse" are spawned close together
    And Nelim's Pickle Tools: 1 adult animals of kind "Wolf_Timber" are spawned close together
    And Nelim's Pickle Tools: 1 adult animals of kind "Fox_Red" are spawned close together
    And Nelim's Pickle Tools: 1 adult animals of kind "Rat" are spawned close together
    When Nelim's Pickle Tools: I frame the animals of kind "Horse"
    And I zoom in
    And I zoom in
    And I wait 10 ticks
    And I take a screenshot "gallery 1 size range"
    Then no errors were logged

  Scenario: image 2, the horse's health tab
    Given Nelim's Pickle Tools: 1 adult animals of kind "Horse" are spawned close together
    When Nelim's Pickle Tools: I frame the animals of kind "Horse"
    And I select "coat-1"
    And Nelim's Pickle Tools: I open the "Health" inspect tab
    Then Nelim's Pickle Tools: the "Health" inspect tab is open
    When I zoom all the way in
    And I follow "coat-1"
    And I wait 10 ticks
    And I take a screenshot "gallery 2 horse health"
    And I stop following
    Then no errors were logged
