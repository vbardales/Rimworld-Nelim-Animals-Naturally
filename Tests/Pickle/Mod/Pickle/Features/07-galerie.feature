# Workshop gallery of Nelim's Animals, Naturally, in upload order (0- is the copy of the Preview, then three pictures).
# Played at Nelim's Sanctuary (SanctuaryBacklot, GALLERY.md), under wsl-deps.galerie.map:
#   Submit-PickleRun.ps1 -Mod AnimalsNaturally -DepMap wsl-deps.galerie.map -Filter '07-galerie' -EvidenceDir Tests/Pickle/Evidence/galerie-N
# They assert almost nothing about the mod (01, 02 and 06 do): a green run says the trip happened, not that a picture shows
# anything. Open every picture before keeping it.
#
#
# THE STORY (rewritten 2026-10-23, one day at Nelim's Sanctuary; Nelim the field naturalist, the only colonist of the save): this
# mod sizes every animal from its real mass relative to a 70 kg human, lengthens or shortens its life, times its pregnancy, and
# hands foraging and a day/night rhythm to animals that lacked them. Nelim herself is the yardstick. 07:00 the feed round among
# the animals, read against her (1); 11:00 her field notes, the Stats card of the elephant (2, interface, set aside); 13:00 a cat
# sleeps in broad day, the night rhythm (3); 18:30 at dusk a hungry grizzly has just dug (4); scene 4, taming and hybrid, dropped 2026-10-23 (no steps), it lives in the card and the subtitles. Berries,
# a grizzly (5). Each scene reloads the save, sets its own hour and waits its own game time (2,500 ticks = 1 game hour).
# ONE OUTFIT ALL DAY (GALLERY.md d, 2026-10-23): Apparel_CollarShirt sage rgb(96,128,84), Apparel_Pants khaki rgb(176,150,100),
# hair Roo_HD_Hair_Highpony (canon high ponytail, never a bun; to verify it is in the DepMap, else Ponytails), hair rgb(70,48,34),
# calm face, no hat. Decor is removed after each shot. Opener = 1 (wide), middle = 3 (close), closer = 5 (dusk).
# GAME PAUSED MID-PLAY (GALLERY.md e): each scene gives a job and pauses a few ticks in; the shot plan lives in STATUS.md
# ("Shotlist 2026-10-23"). THE SCENARIOS BELOW STILL FOLLOW THE OLD PLAN (3 = pheasant, probe, old outfits): rewrite them to
# STATUS.md before any ticket; only 1 and 2 are near ready (scene 1: add `the painted zones are hidden` before the frame step,
# NPT 2026-10-23).
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

  Scenario: workshop 1 - the feed round, Nelim among an elephant, a horse, a cow and a hen at 08:00
    Given Nelim's Sanctuary: I am at the sanctuary "enclosure-south"
    And I set the hour to 8
    And Nelim's Pickle Tools: I let 60 ticks pass
    And game speed is paused
    And Nelim's Pickle Tools: I place the decor "EggBox" at (148, 212)
    And Nelim's Pickle Tools: I place the decor "Plant_YellowTallGrass" at (152, 212) fully grown
    And Nelim's Pickle Tools: an adult animal of kind "Elephant" named "elephant" is spawned at (145, 217)
    And Nelim's Pickle Tools: an adult animal of kind "Horse" named "horse" is spawned at (155, 217)
    And Nelim's Pickle Tools: an adult animal of kind "Cow" named "cow" is spawned at (159, 213)
    And Nelim's Pickle Tools: an adult animal of kind "Chicken" named "hen" is spawned at (150, 211)
    And Nelim's Pickle Tools: "elephant" faces South
    And Nelim's Pickle Tools: "horse" faces South
    And Nelim's Pickle Tools: "cow" faces West
    And Nelim's Pickle Tools: "hen" faces South
    And Nelim's Pickle Tools: "Nelim" wears "Apparel_CollarShirt" dyed rgb (96, 128, 84)
    And Nelim's Pickle Tools: "Nelim" wears "Apparel_Pants" dyed rgb (176, 150, 100)
    And Nelim's Pickle Tools: "Nelim" hairstyle is "Ponytails"
    And Nelim's Pickle Tools: "Nelim" hair colour is rgb (70, 48, 34)
    And Nelim's Pickle Tools: "Nelim" carries 10 of the item "Hay"
    And Nelim's Pickle Tools: "Nelim" stands at (152, 213) facing East
    And Nelim's Sanctuary: Nelim has her own face
    And Nelim's Pickle Tools: "Nelim" face kit is "calm"
    When Nelim's Pickle Tools: I frame the rectangle from (140, 209) to (162, 219)
    And Nelim's Pickle Tools: the map is shown alone for a capture
    And I take a screenshot "workshop-1-feed-round"
    And Nelim's Pickle Tools: the interface is shown again
    Then Nelim's Pickle Tools: the decor is removed
    And no errors were logged

  # galerie-5: the Health tab showed a Dev tool button, 100 percent bars and the resource list (refused). galerie-6: the Stats tab
  # carries the numbers; read and kept. This card is a menu, so it is taken as it is on window-backdrop-for-height with the dev
  # button and the learning helper off, and cropped sideways around the window by hand (GALLERY.md).
  Scenario: workshop 2 - the information card of a horse at 11:00
    Given Nelim's Sanctuary: I am at the sanctuary "window-backdrop-for-height"
    And I set the hour to 11
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
