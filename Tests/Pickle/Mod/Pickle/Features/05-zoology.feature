# Same pass as 03-dogsmate.feature. Zoology is the heaviest of the three: it rewrites animal defs with
# its own patches and C#, which is why the mod loads below it. The mod's numeric families are read
# by attribution only (see 01-baseline), so what this shows is that they still reach their defs when
# Zoology is in the list, and that nothing is logged from this mod.
@requires:com.abobashark.zoologymod
Feature: Nelim's Animals, Naturally beside Zoology

  Scenario: it loads after Zoology and says nothing
    Then mod "com.abobashark.zoologymod" is loaded
    And mod "nelim.animalrebalance" is loaded
    And mod "nelim.animalrebalance" loads after "com.abobashark.zoologymod"
    And no warnings from mod "Nelim's Animals, Naturally"

  Scenario: the patches still reach the vanilla animals Zoology reworks
    Then def "Horse" was patched by mod "Nelim's Animals, Naturally"
    And def "Muffalo" was patched by mod "Nelim's Animals, Naturally"
    And def "Alphabeaver" was patched by mod "Nelim's Animals, Naturally"

  Scenario: the load logs no error
    # Zoology and the pass around it can log errors of their own: if red, read which mod logs it.
    Then no errors were logged
