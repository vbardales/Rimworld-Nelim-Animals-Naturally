# AUDIT 8.h: the mod ships no setting and no MainButtonDef (Check-SettingsContract.ps1 PASS, STATUS.md Settings audit),
# so the Mod options list must show no page for it, and not an empty one. Run with wsl-deps.options.map and -Filter '09-no-options'.
@requires:nelim.pickletools.colonistrace
Feature: Nelim's Animals, Naturally has no Mod options page

  Scenario: the Mod options list holds no entry for the mod
    Then mod "nelim.animalsnaturally" is loaded
    And Nelim's Pickle Tools: the mod options page of the mod "nelim.animalsnaturally" does not exist
    And no warnings from mod "Nelim's Animals, Naturally"
