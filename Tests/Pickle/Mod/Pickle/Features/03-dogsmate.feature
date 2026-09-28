# The pass "avec-loadafter", staged from wsl-deps.avec-loadafter.map. Dogs Mate, Some Like It Rotten
# and Zoology are in About.xml <loadAfter> and are targeted by no XPath of this mod, so what can be
# asserted for each is the load: present, this mod loaded after it, nothing said.
#
# The order is the one the staging wrote into ModsConfig (this mod comes after every mod a map names);
# it is not the game re-sorting from <loadAfter>. That the four ids are the four mods' real packageIds
# is a fact of the sources (checked 2026-09-28 against each mod's About.xml), not of this file.
@requires:Mlie.DogsMate
Feature: Nelim's Animals, Naturally beside Dogs Mate

  Scenario: it loads after Dogs Mate and says nothing
    Then mod "Mlie.DogsMate" is loaded
    And mod "nelim.animalrebalance" is loaded
    And mod "nelim.animalrebalance" loads after "Mlie.DogsMate"
    And no warnings from mod "Nelim's Animals, Naturally"
