# Workshop gallery of Nelim's Animals, Naturally, in upload order (0- is the copy of the Preview, then three pictures).
# Played at Nelim's Sanctuary (SanctuaryBacklot, GALLERY.md), under wsl-deps.galerie.map:
#   Submit-PickleRun.ps1 -Mod AnimalsNaturally -DepMap wsl-deps.galerie.map -Filter '07-galerie' -EvidenceDir Tests/Pickle/Evidence/galerie-N
# They assert almost nothing about the mod (01, 02 and 06 do): a green run says the trip happened, not that a picture shows
# anything. Open every picture before keeping it.
#
# THE STORY (one day at Nelim's Sanctuary, Nelim the field naturalist, the only colonist of the save): this mod sizes every
# animal from its real mass relative to a 70 kg human, so Nelim herself is the unit of measure. 08:00 she feeds and measures the
# animals against herself (scene 1); 11:00 she reads the numbers in her field notes (interface card, scene 2, set aside from
# the scoring, no subtitle); 15:00 a hungry grizzly digs for berries, the foraging this mod hands to animals Animals Forage does
# not cover (scene 3). Each scene reloads the save, sets its own hour, waits its own game time (2,500 ticks = 1 game hour).
# Outfit, hair, face and decor differ on purpose in every scene; every decor piece is removed after its shot.
#
# SHOT PLAN (scored against GALLERY.md a to j, 2026-10-18; below 4 nothing is played):
#   1 workshop-1-feed-round. [4/5]
#     a. enclosure-south, 08:00, Clear, setup 60 ticks then paused.
#     b. EggBox at (148,213) and Plant_YellowTallGrass at (152,213) (a straw nest at the hen's foot), removed after the shot.
#     c. elephant (back left, faces South: front view), horse (background, faces South), cow (right, faces West toward Nelim),
#        hen (foreground at her feet, faces South).
#     d. Nelim: Apparel_CollarShirt dyed sage green rgb(96,128,84), Apparel_Pants dyed khaki rgb(176,150,100), Ponytails,
#        hair rgb(70,48,34), face kit calm (MouthLipsTinySmile, LidSimple, BrowNormal), no hat.
#     e. she carries 10 Hay (the feed round), faces East toward the cow, stood next to the hen.
#     f. frame of about 18 by 9 cells, Nelim off centre right of the middle, hen big in the foreground, elephant largest at the
#        back, morning side light; subject fills at least 60 percent of the height.
#     g. One subject: Nelim against the animals' real size. Says: "Nelim is the yardstick: the hen to her knee, the elephant over her."
#     h. Risk: green tint on the left ground (floor bared) and animals overlapping. Plan: no bared floor unless the tint is gone,
#        read the picture, ask NPT through the TM for a fix; stagger the animals in depth, at least 3 cells between two.
#     i. staggered in depth (three rows of z), turned differently, never a lined row.
#     j. every animal has the body size this mod computes (elephant, horse, cow, hen).
#   2 workshop-2-horse-card. Interface scene, window-backdrop-for-height, 11:00, Stats tab of a horse (body size 1.93, life
#     expectancy 30), cropped sideways by hand, no subtitle, not scored. Linked to scene 1 by the horse and the same Steam text.
#   3 workshop-3-hungry-grizzly. [4/5, conditional on the probe frames]
#     a. plant-garden, 15:00, Clear, setup 477 ticks then paused (the pheasant is dropped).
#     b. PlantPot with Plant_Daylily at (194,89) fully grown, Plant_TreeOak at (196,86) fully grown (shade), removed after.
#     c. grizzly (Bear_Grizzly, food 0 percent, faces South toward the camera), grown plants.
#     d. Nelim: Apparel_Duster dyed ochre rgb(176,104,48) over Apparel_BasicShirt dyed cream rgb(236,226,200), Apparel_Pants dyed
#        dark brown rgb(70,52,40), FancyBun, hair rgb(120,70,40), BrowRaised, MouthSmile, LidCheerful.
#     e. she watches from five cells, faces East, carrying 1 MedicineHerbal (her field kit).
#     f. frame of about 13 by 8 cells, grizzly off centre left and large, Nelim small right, lawn behind, flat afternoon light.
#     g. One subject: a hungry grizzly foraging. Says: "A hungry grizzly digs for berries: the mod gives it the forage of its neighbours."
#     h. Risk: the dig is not visible (unproven). Plan: the `probe` scenario (frames 0, 300, 1200 ticks) of galerie-9 decides the
#        capture tick; fallback RawBerries placed with StageDecor under the bear. Risk 2: the grizzly turns on Nelim. Plan: spawned in
#        the player faction, five cells apart, no drafting.
#     i. one animal, one pawn, plants behind: no row.
#     j. Forage.xml gives the grizzly RawBerries x10 (Pickle 02-forage-vef asserts the guard).
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
