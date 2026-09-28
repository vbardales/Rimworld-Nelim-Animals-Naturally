# Same pass and same reasoning as 03-dogsmate.feature.
@requires:Mlie.SomeLikeItRotten
Feature: Nelim's Animals, Naturally beside Some Like It Rotten

  Scenario: it loads after Some Like It Rotten and says nothing
    Then mod "Mlie.SomeLikeItRotten" is loaded
    And mod "nelim.animalrebalance" is loaded
    And mod "nelim.animalrebalance" loads after "Mlie.SomeLikeItRotten"
    And no warnings from mod "Nelim's Animals, Naturally"
