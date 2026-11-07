# Workshop gallery of Nelim's Animals, Naturally, in upload order (0- is the copy of the Preview, then the pictures below).
# Played at Nelim's Sanctuary (SanctuaryBacklot, GALLERY.md), under wsl-deps.galerie.map:
#   Submit-PickleRun.ps1 -Mod AnimalsNaturally -DepMap wsl-deps.galerie.map -Filter '07-galerie' -EvidenceDir Tests/Pickle/Evidence/galerie-N
# They assert almost nothing about the mod (01, 02 and 06 do): a green run says the trip happened, not that a picture shows
# anything. Open every picture before keeping it.
#
# THE STORY (rewritten 2026-11-07 after NSB validated its animals and places; one day at Nelim's Sanctuary, Nelim the field naturalist,
# the yardstick of the sizes): this mod sizes every animal from its real mass relative to a 70 kg human, lengthens or shortens its life,
# times its pregnancy, and hands foraging and a day/night rhythm to animals that lacked them. 08:00 the feed round at the barn, a hen, a cow,
# a horse and an elephant on one row, read against her (1); the Stats card of the elephant, the numbers behind 1 (2, interface, set aside);
# 13:00 in the tea room a cat sleeps in broad day, the night rhythm (3); 17:00 in the flower garden a hungry grizzly has dug up berries (4);
# 20:00 the same cat wakes and goes out into the night, the day closes (5). Places validated by NSB (VALIDE.md 2026-11-07): barn, hut,
# flower-garden, window-backdrop-for-height. Elephant, horse, cow and hen are not NSB animals: the owner kept them on 2026-11-07
# ("garde les 4", rule 2); the cat is an NSB species (Tama's, not Tama herself), the grizzly is wild decor.
# ONE OUTFIT ALL DAY (GALLERY.md d, 2026-10-23): Apparel_CollarShirt sage rgb (96, 128, 84), Apparel_Pants khaki rgb (176, 150, 100),
# hair Roo_HD_Hair_Highpony (canon), hair rgb (56, 36, 18) (roster #382412), canon mouth MouthLipsSmirk, no smile because the owner refused
# the smiling mouths on 2026-11-05 (a written trait, no malus), LidCheerful, no hat. Decor is removed after each shot.
# Barn and hut cells checked against the free-cells probe of 2026-11-07 (run 9958): every standing, spawn and decor cell is free. Flower-garden cells of scene 4 checked against probe 15a1 (the garden is dense, the open ground is the east block x 163..170, z 108..113).
# Frames use the NPT step "I frame the area centred on (x, z) at root size R" (R 2 to 130; visible 2R rows by 3.56R columns).
# Size limit of the Steam page (owner, 2026-10-06): any number of images, each under 2 MB, all together under 8 MB.
#
# SHOTLIST (one line per picture; the checker reads hours, defNames, coordinates and colours of each line in the scenario of the same rank):
#   1. workshop 1, barn, 8h Clear, 60 + 30 ticks. Nelim carries Hay toward a hen, a cow, a horse and an elephant standing on one row
#        (z equal): Chicken (189, 235), Cow (196, 235), Horse (200, 235), Elephant (204, 235), all facing South. Decor on the yard earth:
#        two Hay stacks (192, 236) and (198, 236), EggBox (191, 237), Plant_YellowTallGrass (199, 238), Plant_Daylily (202, 238),
#        TorchLamp lit at (194, 238), all removed after. Nelim Apparel_Pants rgb (176, 150, 100), Apparel_CollarShirt
#        rgb (96, 128, 84), Roo_HD_Hair_Highpony, MouthLipsSmirk, stands at (194, 234) facing West and is forced to walk to (190, 234),
#        paused 30 ticks in (mid-path). Instant: she has just taken the hay from the stack and is bringing it to the hen. Wide frame
#        centred (197, 235) at root size 5. Says: she brings hay to a hen, a cow, a horse and an elephant.
#   2. interface, workshop 2, window-backdrop-for-height, 11h, the Stats card of the elephant, cropped sideways, no subtitle.
#   3. workshop 3, hut, 13h Clear, 60 + 40 + 30 ticks. akaNEKO_N_Forest_Cat spawned at (140, 73) on the cushion cell, lies down, faces
#        South, Z mote if the game shows one. Nelim in the same outfit (Apparel_Pants rgb (176, 150, 100), Apparel_CollarShirt
#        rgb (96, 128, 84), Roo_HD_Hair_Highpony, MouthLipsSmirk), stands at (142, 74) facing West, forced to walk to (137, 74),
#        paused 30 ticks in. Instant: the cat settled minutes ago, she tiptoes past so as not to wake it. The low table, the cushions and
#        the oil lamp are the validated furniture of the hut (already there). Close frame centred (140, 74) at root size 2.
#        Says: a cat sleeps and Nelim tiptoes past so as not to wake it.
#   4. workshop 4, flower-garden, 17h Clear, 60 + 30 ticks. Bear_Grizzly named bear at (166, 111), food 0 percent, RawBerries placed as decor on (166, 111) (the dig did not drop them in galerie-17)
#        (galerie-17: the grizzly dig dropped nothing on the cell), the bear stands at (166, 112) facing South over RawBerries at (166, 111)
#        unforbidden, Filth_Dirt at (165, 111) and (167, 111), TorchLamp lit at (168, 113). Nelim in the same outfit
#        (Apparel_Pants rgb (176, 150, 100), Apparel_CollarShirt rgb (96, 128, 84), Roo_HD_Hair_Highpony, MouthLipsSmirk) stands
#        at (170, 109) facing West, forced to walk to (168, 109), paused 30 ticks in, looking at the bear 4 cells away.
#        Instant: the dig has just finished, the pile is in front of the bear. Medium frame centred (167, 111) at root size 3.
#        Says: a grizzly has dug up a berry pile.
#   5. workshop 5, hut door, 20h Clear, 60 + 30 ticks. The same akaNEKO_N_Forest_Cat awake at (140, 73), forced to walk to (137, 73) toward
#        the door, TorchLamp lit outside the door at (136, 72). Nelim in the same outfit (Apparel_Pants rgb (176, 150, 100),
#        Apparel_CollarShirt rgb (96, 128, 84), Roo_HD_Hair_Highpony, MouthLipsSmirk) stands at (142, 74) facing West, forced to walk
#        to (140, 74), paused 30 ticks in. Instant: the cat has woken and heads out, she lets it go. Close frame centred (139, 73)
#        at root size 3. Says: the cat wakes and goes out into the night while Nelim watches it go.
#
@requires:OskarPotocki.VanillaFactionsExpanded.Core @requires:nelim.pickletools.stagedecor @requires:nelim.pickletools.inspecttabs @review @en-only
Feature: Gallery pictures of Nelim's Animals, Naturally

  Background:
    Given the save "Nelims-tribe" is loaded
    And game speed is paused
    And I set the hour to 10
    And I set the weather to "Clear"
    And Nelim's Sanctuary: the vanometric cell of the sanctuary is hidden
    And Nelim's Pickle Tools: all animals are removed

  # 1 FEED ROUND (opener, wide). Barn yard, 08:00 Clear, 60 ticks of setup then 30 ticks of walk.
  Scenario: workshop 1 - the feed round at 08:00, Nelim carries hay to a hen, a cow, a horse and an elephant
    Given Nelim's Sanctuary: I am at the sanctuary "barn"
    And I set the hour to 8
    And Nelim's Pickle Tools: I let 60 ticks pass
    And game speed is paused
    And Nelim's Pickle Tools: the painted zones are hidden
    And Nelim's Pickle Tools: I place the decor "Hay" at (192, 236)
    And Nelim's Pickle Tools: I place the decor "Hay" at (198, 236)
    And Nelim's Pickle Tools: I place the decor "EggBox" at (191, 237)
    And Nelim's Pickle Tools: I place the decor "Plant_YellowTallGrass" at (199, 238) fully grown
    And Nelim's Pickle Tools: I place the decor "Plant_Daylily" at (202, 238) fully grown
    And Nelim's Pickle Tools: I place the decor "TorchLamp" at (194, 238)
    And Nelim's Pickle Tools: the decor "TorchLamp" at (194, 238) is lit
    And Nelim's Pickle Tools: an adult animal of kind "Chicken" named "hen" is spawned at (189, 235)
    And Nelim's Pickle Tools: an adult animal of kind "Cow" named "cow" is spawned at (196, 235)
    And Nelim's Pickle Tools: an adult animal of kind "Horse" named "horse" is spawned at (200, 235)
    And Nelim's Pickle Tools: an adult animal of kind "Elephant" named "elephant" is spawned at (204, 235)
    And Nelim's Pickle Tools: "hen" faces South
    And Nelim's Pickle Tools: "cow" faces South
    And Nelim's Pickle Tools: "horse" faces South
    And Nelim's Pickle Tools: "elephant" faces South
    And Nelim's Pickle Tools: "Nelim" wears "Apparel_Pants" dyed rgb (176, 150, 100)
    And Nelim's Pickle Tools: "Nelim" wears "Apparel_CollarShirt" dyed rgb (96, 128, 84)
    And Nelim's Pickle Tools: "Nelim" hairstyle is "Roo_HD_Hair_Highpony"
    And Nelim's Pickle Tools: "Nelim" hair colour is rgb (56, 36, 18)
    And Nelim's Pickle Tools: "Nelim" stands at (194, 234) facing West
    And Nelim's Sanctuary: Nelim has her own face
    And Nelim's Pickle Tools: "Nelim" face kit is "calm"
    And Nelim's Pickle Tools: "Nelim" mouth is "MouthLipsSmirk"
    And Nelim's Pickle Tools: "Nelim" lids are "LidCheerful"
    And Nelim's Pickle Tools: "Nelim" carries the item "Hay"
    And Nelim's Pickle Tools: "Nelim" is forced to walk to (190, 234)
    And Nelim's Pickle Tools: I let 30 ticks pass
    And game speed is paused
    When Nelim's Pickle Tools: I frame the area centred on (197, 235) at root size 5
    And Nelim's Pickle Tools: the map is shown alone for a capture
    And I take a screenshot "workshop-1-feed-round"
    And Nelim's Pickle Tools: the interface is shown again
    Then Nelim's Pickle Tools: the decor is removed
    And no errors were logged

  # 2 STATS CARD (interface window, set aside, no subtitle). window-backdrop-for-height, 11:00. The elephant is spawned on the smiley-west
  # carpet (93, 100), a cell known to be free, and selected by name: the card does not need it in the frame.
  Scenario: workshop 2 - interface window, the Stats card of the elephant at 11:00
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

  # 3 CAT ASLEEP AT NOON (close). Tea room, 13:00 Clear, 60 + 40 + 30 ticks.
  Scenario: workshop 3 - a cat sleeps at 13:00, Nelim tiptoes past
    Given Nelim's Sanctuary: I am at the sanctuary "hut"
    And I set the hour to 13
    And Nelim's Pickle Tools: I let 60 ticks pass
    And game speed is paused
    And Nelim's Pickle Tools: an adult animal of kind "akaNEKO_N_Forest_Cat" named "cat" is spawned at (140, 73)
    And Nelim's Pickle Tools: "cat" faces South
    And Nelim's Pickle Tools: "cat" lies down
    And Nelim's Pickle Tools: I let 40 ticks pass
    And game speed is paused
    And Nelim's Pickle Tools: "Nelim" wears "Apparel_Pants" dyed rgb (176, 150, 100)
    And Nelim's Pickle Tools: "Nelim" wears "Apparel_CollarShirt" dyed rgb (96, 128, 84)
    And Nelim's Pickle Tools: "Nelim" hairstyle is "Roo_HD_Hair_Highpony"
    And Nelim's Pickle Tools: "Nelim" hair colour is rgb (56, 36, 18)
    And Nelim's Pickle Tools: "Nelim" stands at (142, 74) facing West
    And Nelim's Sanctuary: Nelim has her own face
    And Nelim's Pickle Tools: "Nelim" face kit is "calm"
    And Nelim's Pickle Tools: "Nelim" mouth is "MouthLipsSmirk"
    And Nelim's Pickle Tools: "Nelim" lids are "LidCheerful"
    And Nelim's Pickle Tools: "Nelim" is forced to walk to (137, 74)
    And Nelim's Pickle Tools: I let 30 ticks pass
    And game speed is paused
    When Nelim's Pickle Tools: I frame the area centred on (140, 74) at root size 2
    And Nelim's Pickle Tools: the map is shown alone for a capture
    And I take a screenshot "workshop-3-cat-asleep"
    And Nelim's Pickle Tools: the interface is shown again
    Then no errors were logged

  # 4 GRIZZLY AT 17:00 (medium). Flower garden, 17:00 Clear, 60 + 30 ticks. The pile is placed as decor (galerie-17: the dig dropped nothing on the cell)
  # (the bear then steps one cell north so the pile is in front of it).
  Scenario: workshop 4 - a hungry grizzly has dug up berries at 17:00
    Given Nelim's Sanctuary: I am at the sanctuary "flower-garden"
    And I set the hour to 17
    And Nelim's Pickle Tools: I let 60 ticks pass
    And game speed is paused
    And Nelim's Pickle Tools: I place the decor "TorchLamp" at (168, 113)
    And Nelim's Pickle Tools: the decor "TorchLamp" at (168, 113) is lit
    And Nelim's Pickle Tools: an adult animal of kind "Bear_Grizzly" named "bear" is spawned at (166, 111)
    And Nelim's Pickle Tools: the animal "bear" has food at 0 percent
    And Nelim's Pickle Tools: "bear" faces South
    And Nelim's Pickle Tools: I place the decor "RawBerries" at (166, 111)
    And game speed is paused
    And Nelim's Pickle Tools: the animal "bear" stands at (166, 112) facing South
    And Nelim's Pickle Tools: I place the decor "Filth_Dirt" at (165, 111)
    And Nelim's Pickle Tools: I place the decor "Filth_Dirt" at (167, 111)
    And Nelim's Pickle Tools: the thing "RawBerries" at (166, 111) is not forbidden
    And Nelim's Pickle Tools: "Nelim" wears "Apparel_Pants" dyed rgb (176, 150, 100)
    And Nelim's Pickle Tools: "Nelim" wears "Apparel_CollarShirt" dyed rgb (96, 128, 84)
    And Nelim's Pickle Tools: "Nelim" hairstyle is "Roo_HD_Hair_Highpony"
    And Nelim's Pickle Tools: "Nelim" hair colour is rgb (56, 36, 18)
    And Nelim's Pickle Tools: "Nelim" stands at (170, 109) facing West
    And Nelim's Sanctuary: Nelim has her own face
    And Nelim's Pickle Tools: "Nelim" face kit is "calm"
    And Nelim's Pickle Tools: "Nelim" mouth is "MouthLipsSmirk"
    And Nelim's Pickle Tools: "Nelim" lids are "LidCheerful"
    And Nelim's Pickle Tools: "Nelim" is forced to walk to (168, 109)
    And Nelim's Pickle Tools: I let 30 ticks pass
    And game speed is paused
    When Nelim's Pickle Tools: I frame the area centred on (167, 111) at root size 3
    And Nelim's Pickle Tools: the map is shown alone for a capture
    And I take a screenshot "workshop-4-grizzly-dig"
    And Nelim's Pickle Tools: the interface is shown again
    Then Nelim's Pickle Tools: the decor is removed
    And no errors were logged

  # 5 THE CAT WAKES (closer). Tea room door, 20:00 Clear, 60 + 30 ticks.
  Scenario: workshop 5 - at 20:00 the cat wakes and goes out, Nelim lets it go
    Given Nelim's Sanctuary: I am at the sanctuary "hut"
    And I set the hour to 20
    And Nelim's Pickle Tools: I let 60 ticks pass
    And game speed is paused
    And Nelim's Pickle Tools: I place the decor "TorchLamp" at (136, 72)
    And Nelim's Pickle Tools: the decor "TorchLamp" at (136, 72) is lit
    And Nelim's Pickle Tools: an adult animal of kind "akaNEKO_N_Forest_Cat" named "cat" is spawned at (140, 73)
    And Nelim's Pickle Tools: "cat" faces West
    And Nelim's Pickle Tools: "Nelim" wears "Apparel_Pants" dyed rgb (176, 150, 100)
    And Nelim's Pickle Tools: "Nelim" wears "Apparel_CollarShirt" dyed rgb (96, 128, 84)
    And Nelim's Pickle Tools: "Nelim" hairstyle is "Roo_HD_Hair_Highpony"
    And Nelim's Pickle Tools: "Nelim" hair colour is rgb (56, 36, 18)
    And Nelim's Pickle Tools: "Nelim" stands at (142, 74) facing West
    And Nelim's Sanctuary: Nelim has her own face
    And Nelim's Pickle Tools: "Nelim" face kit is "calm"
    And Nelim's Pickle Tools: "Nelim" mouth is "MouthLipsSmirk"
    And Nelim's Pickle Tools: "Nelim" lids are "LidCheerful"
    And Nelim's Pickle Tools: "cat" is forced to walk to (137, 73)
    And Nelim's Pickle Tools: "Nelim" is forced to walk to (140, 74)
    And Nelim's Pickle Tools: I let 30 ticks pass
    And game speed is paused
    When Nelim's Pickle Tools: I frame the area centred on (139, 73) at root size 3
    And Nelim's Pickle Tools: the map is shown alone for a capture
    And I take a screenshot "workshop-5-cat-wakes"
    And Nelim's Pickle Tools: the interface is shown again
    Then Nelim's Pickle Tools: the decor is removed
    And no errors were logged
