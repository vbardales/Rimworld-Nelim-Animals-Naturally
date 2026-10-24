# Workshop gallery of Nelim's Animals, Naturally, in upload order (0- is the copy of the Preview, then four pictures).
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
# sleeps in broad day, the night rhythm (3); 18:00 at dusk a hungry grizzly has just dug for berries (4). The taming and hybrid scene
# was dropped 2026-10-23 (no steps). Each scene reloads the save, sets its own hour and waits its own game time (2,500 ticks = 1 game hour).
# ONE OUTFIT ALL DAY (GALLERY.md d, 2026-10-23): Apparel_CollarShirt sage rgb(96,128,84), Apparel_Pants khaki rgb(176,150,100),
# hair Ponytails (the canon Roo_HD_Hair_Highpony is not in wsl-deps.galerie.map), hair rgb(70,48,34),
# a smile (MouthSmile, LidCheerful) in 1 and 3, a closed mouth (MouthLipsTinySmile) beside the grizzly in 4, no hat. The cat of 3 is Tama (akaNEKO_N_Forest_Cat). Decor is removed after each shot. Opener = 1 (wide), middle = 3 (close), closer = 4 (dusk).
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

  # 1 FEED ROUND (opener, wide). enclosure-south, 07:00 Clear, 60 ticks of setup then 30 ticks of walk. Hay at the cow's feet, EggBox and
  # a straw nest at the hen. Instant: just after the hay drop, the cow steps toward it, the hen heads for her nest, Nelim crosses to the EggBox,
  # all three mid-stride (forced to walk, 30 ticks, paused). Frame 19 x 10 cells: at 268 px the elephant is about 42 px, the cow 28, Nelim and the
  # hen 14: silhouettes read, the scale is the elephant against the hen. Foreground hen and Nelim, elephant back left, horse back centre. Risk: the tint.
  Scenario: workshop 1 - the feed round at 07:00, Nelim walks past an elephant, a horse, a cow and a hen
    Given Nelim's Sanctuary: I am at the sanctuary "enclosure-south"
    And I set the hour to 7
    And Nelim's Pickle Tools: I let 60 ticks pass
    And game speed is paused
    And Nelim's Pickle Tools: the painted zones are hidden
    And Nelim's Pickle Tools: the pollution is cleared from the area from (138, 204) to (167, 224)
    And Nelim's Pickle Tools: I place the decor "EggBox" at (148, 212)
    And Nelim's Pickle Tools: I place the decor "Plant_YellowTallGrass" at (152, 212) fully grown
    And Nelim's Pickle Tools: I place the decor "Hay" at (158, 213)
    And Nelim's Pickle Tools: an adult animal of kind "Elephant" named "elephant" is spawned at (145, 217)
    And Nelim's Pickle Tools: an adult animal of kind "Horse" named "horse" is spawned at (155, 217)
    And Nelim's Pickle Tools: an adult animal of kind "Cow" named "cow" is spawned at (161, 213)
    And Nelim's Pickle Tools: an adult animal of kind "Chicken" named "hen" is spawned at (150, 211)
    And Nelim's Pickle Tools: "elephant" faces South
    And Nelim's Pickle Tools: "horse" faces South
    And Nelim's Pickle Tools: "cow" faces West
    And Nelim's Pickle Tools: "hen" faces South
    And Nelim's Pickle Tools: "Nelim" wears "Apparel_Pants" dyed rgb (176, 150, 100)
    And Nelim's Pickle Tools: "Nelim" wears "Apparel_CollarShirt" dyed rgb (96, 128, 84)
    And Nelim's Pickle Tools: "Nelim" hairstyle is "Ponytails"
    And Nelim's Pickle Tools: "Nelim" hair colour is rgb (70, 48, 34)
    And Nelim's Pickle Tools: "Nelim" stands at (156, 213) facing West
    And Nelim's Sanctuary: Nelim has her own face
    And Nelim's Pickle Tools: "Nelim" face kit is "calm"
    And Nelim's Pickle Tools: "Nelim" mouth is "MouthSmile"
    And Nelim's Pickle Tools: "Nelim" lids are "LidCheerful"
    And Nelim's Pickle Tools: "cow" is forced to walk to (158, 213)
    And Nelim's Pickle Tools: "hen" is forced to walk to (152, 212)
    And Nelim's Pickle Tools: "Nelim" is forced to walk to (149, 213)
    And Nelim's Pickle Tools: I let 30 ticks pass
    And game speed is paused
    When Nelim's Pickle Tools: I frame the rectangle from (143, 209) to (162, 219)
    And Nelim's Pickle Tools: the map is shown alone for a capture
    And I take a screenshot "workshop-1-feed-round"
    And Nelim's Pickle Tools: the interface is shown again
    Then Nelim's Pickle Tools: the decor is removed
    And no errors were logged

  # 2 FIELD NOTES (interface card, set aside, no subtitle). window-backdrop-for-height, 11:00. The elephant of scene 1 is spawned on the
  # smiley-west carpet (93, 100), a cell known to be free, and selected by name: the card does not need it in the frame.
  Scenario: workshop 2 - the Stats card of the elephant at 11:00
    Given Nelim's Sanctuary: I am at the sanctuary "window-backdrop-for-height"
    And I set the hour to 11
    And Nelim's Pickle Tools: I let 268 ticks pass
    And game speed is paused
    And Nelim's Pickle Tools: the learning helper is hidden
    And Nelim's Pickle Tools: an adult animal of kind "Elephant" named "coat-1" is spawned at (93, 100)
    When I select "coat-1"
    And Nelim's Pickle Tools: developer mode is turned off for the capture
    And Nelim's Pickle Tools: I open the info card of the selected thing on the "Stats" tab
    And Nelim's Pickle Tools: screenshot mode is enabled around the open windows
    And I take a screenshot "workshop-2-elephant-card"
    And Nelim's Pickle Tools: the interface is shown again
    And Nelim's Pickle Tools: I close the info card
    Then no errors were logged

  # 3 CAT ASLEEP AT NOON (close). sofa-corner, 13:00. Vanilla Cat is Nocturnal in Rythme.xml: asleep in broad day. Instant: Nelim tiptoes
  # past toward the door. Props already there (SANCTUAIRE-CASES.md): Couch (185,123) and (187,122), TorchLamp (187,121), BookcaseSmall (182,124), PlantPot
  # (191,122). Instant: the cat settled minutes ago, Nelim is leaving without waking it (forced to walk, 30 ticks). Frame 7 x 5 cells, about 30 px a cell
  # at 268 px: the curled cat with its Zzz mote in the foreground low left, Nelim small behind on row 126, the couches and the lamp light behind.
  Scenario: workshop 3 - a cat sleeps at 13:00, Nelim tiptoes past
    Given Nelim's Sanctuary: I am at the sanctuary "sofa-corner"
    And I set the hour to 13
    And Nelim's Pickle Tools: I let 60 ticks pass
    And game speed is paused
    And Nelim's Pickle Tools: an adult animal of kind "akaNEKO_N_Forest_Cat" named "cat" is spawned at (186, 124)
    And Nelim's Pickle Tools: "cat" faces South
    And Nelim's Pickle Tools: "cat" lies down
    And Nelim's Pickle Tools: I let 40 ticks pass
    And game speed is paused
    And Nelim's Pickle Tools: "Nelim" wears "Apparel_Pants" dyed rgb (176, 150, 100)
    And Nelim's Pickle Tools: "Nelim" wears "Apparel_CollarShirt" dyed rgb (96, 128, 84)
    And Nelim's Pickle Tools: "Nelim" hairstyle is "Ponytails"
    And Nelim's Pickle Tools: "Nelim" hair colour is rgb (70, 48, 34)
    And Nelim's Pickle Tools: "Nelim" stands at (190, 126) facing West
    And Nelim's Sanctuary: Nelim has her own face
    And Nelim's Pickle Tools: "Nelim" face kit is "calm"
    And Nelim's Pickle Tools: "Nelim" mouth is "MouthSmile"
    And Nelim's Pickle Tools: "Nelim" lids are "LidCheerful"
    And Nelim's Pickle Tools: "Nelim" is forced to walk to (184, 126)
    And Nelim's Pickle Tools: I let 30 ticks pass
    And game speed is paused
    When Nelim's Pickle Tools: I frame the rectangle from (184, 122) to (191, 127)
    And Nelim's Pickle Tools: the map is shown alone for a capture
    And I take a screenshot "workshop-3-cat-asleep"
    And Nelim's Pickle Tools: the interface is shown again
    Then no errors were logged

  # 4 GRIZZLY AT DUSK (closer). plant-garden, 18:00 Clear, torch lit. Instant: just after the dig, the berries under the bear, Nelim walks
  # home. Instant: the dig has just finished (tick 300 in the probe), the grizzly stands over the pile facing South, Nelim slows by it (3 cells, forced to
  # walk 30 ticks). Frame 10 x 6 cells, about 25 px a cell at 268 px: bear 50 px, pile 25 px, lamp pool behind. Foreground bear and pile off-centre right,
  # Nelim mid-left. The probe (galerie-11) showed the stack under the grizzly at tick 300. The stack cell is a guess from that frame (about (193, 85)):
  # the first screenshot is taken before the unforbid step, so a wrong cell still leaves a picture and the failure names what the cell holds.
  Scenario: workshop 4 - a hungry grizzly has just dug for berries at dusk
    Given Nelim's Sanctuary: I am at the sanctuary "plant-garden"
    And I set the hour to 18
    And Nelim's Pickle Tools: I let 60 ticks pass
    And game speed is paused
    And Nelim's Pickle Tools: I place the decor "TorchLamp" at (189, 89)
    And Nelim's Pickle Tools: the decor "TorchLamp" at (189, 89) is lit
    And Nelim's Pickle Tools: an adult animal of kind "Bear_Grizzly" named "bear" is spawned at (193, 86)
    And Nelim's Pickle Tools: the animal "bear" has food at 0 percent
    And Nelim's Pickle Tools: "bear" faces South
    And Nelim's Pickle Tools: I let 270 ticks pass
    And game speed is paused
    And Nelim's Pickle Tools: "Nelim" wears "Apparel_Pants" dyed rgb (176, 150, 100)
    And Nelim's Pickle Tools: "Nelim" wears "Apparel_CollarShirt" dyed rgb (96, 128, 84)
    And Nelim's Pickle Tools: "Nelim" hairstyle is "Ponytails"
    And Nelim's Pickle Tools: "Nelim" hair colour is rgb (70, 48, 34)
    And Nelim's Pickle Tools: "Nelim" stands at (190, 87) facing West
    And Nelim's Sanctuary: Nelim has her own face
    And Nelim's Pickle Tools: "Nelim" face kit is "calm"
    And Nelim's Pickle Tools: "Nelim" mouth is "MouthLipsTinySmile"
    And Nelim's Pickle Tools: "bear" faces South
    And Nelim's Pickle Tools: "Nelim" is forced to walk to (187, 87)
    And Nelim's Pickle Tools: I let 30 ticks pass
    And game speed is paused
    When Nelim's Pickle Tools: I frame the rectangle from (186, 83) to (196, 89)
    And Nelim's Pickle Tools: the map is shown alone for a capture
    And I take a screenshot "workshop-4-before-unforbid"
    And Nelim's Pickle Tools: the thing "RawBerries" at (193, 85) is not forbidden
    And I take a screenshot "workshop-4-grizzly-dusk"
    And Nelim's Pickle Tools: the interface is shown again
    Then Nelim's Pickle Tools: the decor is removed
    And no errors were logged
