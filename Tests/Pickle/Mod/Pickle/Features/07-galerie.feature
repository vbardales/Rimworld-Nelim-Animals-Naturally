# Workshop gallery of Nelim's Animals, Naturally, in upload order (0- is the copy of the Preview, then three pictures).
# Played at Nelim's Sanctuary (SanctuaryBacklot, GALLERY.md), under wsl-deps.galerie.map:
#   Submit-PickleRun.ps1 -Mod AnimalsNaturally -DepMap wsl-deps.galerie.map -Filter '07-galerie' -EvidenceDir Tests/Pickle/Evidence/galerie-N
# They assert almost nothing about the mod (01, 02 and 06 do): a green run says the trip happened, not that a picture shows
# anything. Open every picture before keeping it.
#
# THE STORY: one morning at Nelim's Sanctuary, Nelim is the field naturalist of the animals. This mod sizes every animal from
# its real mass, relative to a 70 kg human: Nelim herself is the unit of measure. She stands among the animals as the yardstick,
# reads the numbers on a card, then watches a hungry pheasant do what this mod hands to it. Nelim is the protagonist of every
# frame (the only colonist of the save, so nobody is sent away): same outfit throughout, a mustard shirt and dark denim trousers
# (they stand out from brown soil, grey elephant and green garden), her own hairstyle and her own face (two eyebrows, dark
# brown eyes), then one expression per picture. Time unfolds: each scenario reloads the save, sets 10 h once, waits the elapsed
# game time (setup 60 ticks, then +5 game minutes per picture: 10:00, 10:05, 10:10). All animals are day animals and face
# the camera (South) unless the picture says otherwise.
#
# SHOT PLAN (place, moment, subject, composition, what lives there, what it says):
#   1 enclosure-south, 10:00. Nelim stands in the middle of a line of animals, facing the camera, smiling: the elephant to
#     her left, her hen at her foot, then the horse and the cow to her right, all facing the camera; frame of about 21 by
#     9 cells. Two pots of daylilies at the left edge for a field-station feel. Says: a body size follows the cube root of
#     the mass, and Nelim is the unit (70 kg = 1.0): the hen is tiny, the horse a little taller, the elephant huge.
#   2 window-backdrop-for-height, 10:05. The information card of a horse on the Stats tab (body size 1.93, life expectancy
#     30), a menu taken as it is (developer mode off, no learning helper), cropped sideways to the window by hand. Says:
#     the numbers behind the pictures, Nelim's field notes.
#   3 plant-garden, 10:10. A hungry royal pheasant (Vanilla Animals Expanded - Royal Animals) faces the camera on the lawn,
#     a standing lamp and daylilies around it; Nelim stands to its left, turned toward it, eyebrows raised and a small
#     smile: she is watching it. Frame of about 11 by 7 cells. Says: this mod hands the forage-when-hungry behaviour to
#     animals Animals Forage does not cover; whether the pheasant digs is read on the picture (02-forage-vef asserts it).
# Zoom rule (owner, 2026-10-02): the subject fills at least 50 percent of the screen height or width. Each frame step
# asks for 60 percent of the rectangle that holds the subject; whether it did is read on the picture.
# Size limit of the Steam page (owner, 2026-10-06): any number of images, each under 2 MB, all together under 8 MB.
#
# Steps: the places and their cleaning are Nelim's Sanctuary: steps (SanctuaryBacklot); the generic tools (presentation mode,
# decor, framing, animals, ticks, faces, clothes, standing) are Nelim's Pickle Tools: steps (PickleTools). Odyssey is on in the save.
@requires:OskarPotocki.VanillaFactionsExpanded.Core @requires:nelim.pickletools.stagedecor @requires:nelim.pickletools.inspecttabs @review @en-only
Feature: Gallery pictures of Nelim's Animals, Naturally

  Background:
    Given the save "Nelims-tribe" is loaded
    And game speed is paused
    And I set the hour to 10
    And I set the weather to "Clear"
    And Nelim's Sanctuary: the vanometric cell of the sanctuary is hidden
    And Nelim's Pickle Tools: all animals are removed

  Scenario: workshop 1 - Nelim among an elephant, a horse, a cow and a hen at their real scale
    Given Nelim's Sanctuary: I am at the sanctuary "enclosure-south"
    And Nelim's Pickle Tools: I let 60 ticks pass
    And game speed is paused
    And Nelim's Pickle Tools: the floor of the area from (140, 210) to (162, 218) is bared like the cell (158, 216)
    And Nelim's Pickle Tools: I place the decor "PlantPot" at (141, 211)
    And Nelim's Pickle Tools: I place the decor "Plant_Daylily" at (141, 212) fully grown
    And Nelim's Pickle Tools: an adult animal of kind "Elephant" named "elephant" is spawned at (145, 214)
    And Nelim's Pickle Tools: an adult animal of kind "Chicken" named "hen" is spawned at (150, 216)
    And Nelim's Pickle Tools: an adult animal of kind "Horse" named "horse" is spawned at (154, 214)
    And Nelim's Pickle Tools: an adult animal of kind "Cow" named "cow" is spawned at (158, 214)
    And Nelim's Pickle Tools: "elephant" faces South
    And Nelim's Pickle Tools: "hen" faces South
    And Nelim's Pickle Tools: "horse" faces South
    And Nelim's Pickle Tools: "cow" faces South
    And Nelim's Pickle Tools: "Nelim" wears "Apparel_Pants" dyed rgb (58, 70, 92)
    And Nelim's Pickle Tools: "Nelim" wears "Apparel_BasicShirt" dyed rgb (214, 168, 52)
    And Nelim's Pickle Tools: "Nelim" stands at (150, 214) facing South
    And Nelim's Sanctuary: Nelim has her own face
    And Nelim's Pickle Tools: "Nelim" mouth is "MouthSmile"
    And Nelim's Pickle Tools: "Nelim" lids are "LidCheerful"
    When Nelim's Pickle Tools: I frame the rectangle from (140, 210) to (162, 218)
    And Nelim's Pickle Tools: the map is shown alone for a capture
    And I take a screenshot "workshop-1-scale"
    And Nelim's Pickle Tools: the interface is shown again
    Then Nelim's Pickle Tools: the decor is removed
    And no errors were logged

  # galerie-5: the Health tab showed a Dev tool button, 100 percent bars and the resource list (refused). galerie-6: the Stats tab
  # carries the numbers; read and kept. This card is a menu, so it is taken as it is on window-backdrop-for-height with the dev
  # button and the learning helper off, and cropped sideways around the window by hand (GALLERY.md).
  Scenario: workshop 2 - the information card of a horse, five minutes later
    Given Nelim's Sanctuary: I am at the sanctuary "window-backdrop-for-height"
    And Nelim's Pickle Tools: I let 268 ticks pass
    And game speed is paused
    And Nelim's Pickle Tools: the learning helper is hidden
    And Nelim's Pickle Tools: 1 adult animals of kind "Horse" are spawned around (90, 140)
    When I select "coat-1"
    And Nelim's Pickle Tools: developer mode is turned off for the capture
    And Nelim's Pickle Tools: I open the info card of the selected thing on the "Stats" tab
    And Nelim's Pickle Tools: screenshot mode is enabled around the open windows
    And I take a screenshot "workshop-2-horse-card"
    And Nelim's Pickle Tools: the interface is shown again
    And Nelim's Pickle Tools: I close the info card
    Then no errors were logged

  # PROBE (2026-10-17, to be deleted once picture 3 is designed): what a hungry grizzly (Bear_Grizzly, RawBerries x10 by Forage.xml)
  # looks like over time, three frames. Read the three pictures: is there a visible dig, a pile of berries, and when.
  Scenario: probe - a hungry grizzly digs for berries, three frames
    Given Nelim's Sanctuary: I am at the sanctuary "plant-garden"
    And Nelim's Pickle Tools: I let 477 ticks pass
    And game speed is paused
    And Nelim's Pickle Tools: 1 adult animals of kind "Bear_Grizzly" are spawned around (191, 88)
    And Nelim's Pickle Tools: the animals of kind "Bear_Grizzly" have food at 0 percent
    And Nelim's Pickle Tools: "Nelim" stands at (186, 88) facing East
    When Nelim's Pickle Tools: I frame the rectangle from (184, 84) to (197, 92)
    And Nelim's Pickle Tools: the map is shown alone for a capture
    And I take a screenshot "probe-0"
    And Nelim's Pickle Tools: the interface is shown again
    And Nelim's Pickle Tools: I let 300 ticks pass
    And game speed is paused
    And Nelim's Pickle Tools: the map is shown alone for a capture
    And I take a screenshot "probe-300"
    And Nelim's Pickle Tools: the interface is shown again
    And Nelim's Pickle Tools: I let 900 ticks pass
    And game speed is paused
    And Nelim's Pickle Tools: the map is shown alone for a capture
    And I take a screenshot "probe-1200"
    And Nelim's Pickle Tools: the interface is shown again
    Then no errors were logged

  Scenario: workshop 3 - Nelim watches a hungry royal pheasant forage, ten minutes in
    Given Nelim's Sanctuary: I am at the sanctuary "plant-garden"
    And Nelim's Pickle Tools: I let 477 ticks pass
    And game speed is paused
    And Nelim's Pickle Tools: 1 adult animals of kind "VAERoy_Pheasant" are spawned around (191, 88)
    And Nelim's Pickle Tools: the animals of kind "VAERoy_Pheasant" have food at 0 percent
    And Nelim's Pickle Tools: the animal "coat-1" stands at (191, 88) facing South
    And Nelim's Pickle Tools: I place the decor "StandingLamp" at (187, 89)
    And Nelim's Pickle Tools: I place the decor "Plant_Daylily" at (194, 89) fully grown
    And Nelim's Pickle Tools: "Nelim" wears "Apparel_Pants" dyed rgb (58, 70, 92)
    And Nelim's Pickle Tools: "Nelim" wears "Apparel_BasicShirt" dyed rgb (214, 168, 52)
    And Nelim's Pickle Tools: "Nelim" stands at (189, 88) facing East
    And Nelim's Sanctuary: Nelim has her own face
    And Nelim's Pickle Tools: "Nelim" brows are "BrowRaised"
    And Nelim's Pickle Tools: "Nelim" mouth is "MouthSmile"
    And Nelim's Pickle Tools: "Nelim" lids are "LidCheerful"
    When Nelim's Pickle Tools: I frame the rectangle from (186, 85) to (195, 90)
    And Nelim's Pickle Tools: the map is shown alone for a capture
    And I take a screenshot "workshop-3-pheasant"
    And Nelim's Pickle Tools: the interface is shown again
    Then Nelim's Pickle Tools: the decor is removed
    And no errors were logged
