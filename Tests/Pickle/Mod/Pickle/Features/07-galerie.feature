# Workshop gallery of Nelim's Animals, Naturally, in upload order (0- is the copy of the Preview, then three pictures).
# Played at Nelim's Sanctuary (SanctuaryBacklot, GALLERY.md), under wsl-deps.galerie.map:
#   Submit-PickleRun.ps1 -Mod AnimalsNaturally -DepMap wsl-deps.galerie.map -Filter '07-galerie' -EvidenceDir Tests/Pickle/Evidence/galerie-N
# They assert almost nothing about the mod (01, 02 and 06 do): a green run says the trip happened, not that a picture shows
# anything. Open every picture before keeping it.
#
# THE STORY: one morning at Nelim's Sanctuary, told like a wildlife magazine report on proportion. What this mod does is
# make animals the right size for what they weigh, so the series shows animals meeting at their real scale, one place after
# the other. Time unfolds in the series: each scenario reloads the save, sets 10 h once, waits the elapsed game time
# (setup 60 ticks, then +5 game minutes per picture, 208 ticks), and only then poses the animals: 10:00, 10:05, 10:10.
# All animals are day animals. Nobody is on the map but the animals (the colonists are sent to the map corner).
#
# SHOT PLAN (place, moment, subject, composition, what lives there, what it says):
#   1 enclosure-south, 10:00. An elephant, a horse, a cow and a hen on one line of the south enclosure, framed as a
#     rectangle that fills the width. The hen stands at the elephant's foot, the horse and the cow stand off-centre to the
#     right. Says: a body size follows the cube root of the mass, a hen is small beside an elephant and the horse sits
#     where its mass puts it. Lamp-free, plain daylight; two pots of daylilies grown at the left edge for a field-station feel.
#   2 window-backdrop-for-height, 10:05 (withdrawn, @wip, until PickleTools has the step): the information card of a horse
#     (body size, life expectancy, gestation), a menu taken as it is, cropped sideways. Says: the numbers behind the picture.
#   3 plant-garden, 10:10. One royal pheasant (Vanilla Animals Expanded - Royal Animals), hungry, on the plant garden
#     lawn, a standing lamp and daylilies around it, framed close and slightly off-centre. Says: this mod hands the
#     forage-when-hungry behaviour to animals Animals Forage does not cover; whether the pheasant digs is read on the picture
#     (nothing asserts it here, 02-forage-vef does).
# Zoom rule (owner, 2026-10-02): the subject fills at least 50 percent of the screen height or width. Each frame step
# asks for 60 percent of the rectangle that holds the subject; whether it did is read on the picture.
# Size limit of the Steam page (owner, 2026-10-06): any number of images, each under 2 MB, all together under 8 MB.
#
# Steps: the places and their cleaning are Nelim's Sanctuary: steps (SanctuaryBacklot); the generic tools (presentation mode,
# decor, framing, animals, ticks) are Nelim's Pickle Tools: steps (PickleTools). Odyssey is on in the save.
@requires:OskarPotocki.VanillaFactionsExpanded.Core @requires:nelim.pickletools.stagedecor @review @en-only
Feature: Gallery pictures of Nelim's Animals, Naturally

  Background:
    Given the save "Nelims-tribe" is loaded
    And game speed is paused
    And I set the hour to 10
    And I set the weather to "Clear"
    And Nelim's Pickle Tools: the colonists are sent to the map corner
    And Nelim's Sanctuary: the vanometric cell of the sanctuary is hidden
    And Nelim's Pickle Tools: all animals are removed

  Scenario: workshop 1 - an elephant, a horse, a cow and a hen at their real scale
    Given Nelim's Sanctuary: I am at the sanctuary "enclosure-south"
    And Nelim's Pickle Tools: I let 60 ticks pass
    And game speed is paused
    And Nelim's Pickle Tools: I place the decor "PlantPot" at (141, 211)
    And Nelim's Pickle Tools: I place the decor "Plant_Daylily" at (141, 212) fully grown
    And Nelim's Pickle Tools: an adult animal of kind "Elephant" named "elephant" is spawned at (146, 214)
    And Nelim's Pickle Tools: an adult animal of kind "Chicken" named "hen" is spawned at (143, 215)
    And Nelim's Pickle Tools: an adult animal of kind "Horse" named "horse" is spawned at (151, 213)
    And Nelim's Pickle Tools: an adult animal of kind "Cow" named "cow" is spawned at (156, 214)
    When Nelim's Pickle Tools: I frame the rectangle from (139, 209) to (162, 219)
    And Nelim's Pickle Tools: studio presentation mode is enabled
    And I take a screenshot "workshop-1-scale"
    Then Nelim's Pickle Tools: the decor is removed
    And no errors were logged

  # WITHDRAWN until PickleTools has a step that opens the information card ("i" button) of the selected animal: the Health tab
  # of galerie-2 showed 100 percent bars, no life expectancy, a Dev tool button and the resource list. The picture to take is the
  # card (body size, life expectancy, gestation) on window-backdrop-for-height, cropped sideways around the window.
  @wip
  Scenario: workshop 2 - the Health tab of a horse, five minutes later
    Given Nelim's Sanctuary: I am at the sanctuary "flower-garden"
    And Nelim's Pickle Tools: I let 268 ticks pass
    And game speed is paused
    And Nelim's Pickle Tools: 1 adult animals of kind "Horse" are spawned around (154, 105)
    When I select "coat-1"
    And Nelim's Pickle Tools: I open the "Health" inspect tab
    Then Nelim's Pickle Tools: the "Health" inspect tab is open
    When I take a screenshot "workshop-2-horse-health"
    Then no errors were logged

  Scenario: workshop 3 - a royal pheasant forages, ten minutes in
    Given Nelim's Sanctuary: I am at the sanctuary "plant-garden"
    And Nelim's Pickle Tools: I let 477 ticks pass
    And game speed is paused
    And Nelim's Pickle Tools: 1 adult animals of kind "VAERoy_Pheasant" are spawned around (190, 86)
    And Nelim's Pickle Tools: the animals of kind "VAERoy_Pheasant" have food at 0 percent
    And Nelim's Pickle Tools: I place the decor "StandingLamp" at (186, 86)
    And Nelim's Pickle Tools: I place the decor "Plant_Daylily" at (193, 87) fully grown
    And Nelim's Pickle Tools: I let 600 ticks pass
    And game speed is paused
    When Nelim's Pickle Tools: the camera is centered on "coat-1" at root size 4
    And Nelim's Pickle Tools: studio presentation mode is enabled
    And I take a screenshot "workshop-3-pheasant"
    Then Nelim's Pickle Tools: the decor is removed
    And no errors were logged
