Feature: Upload a demo
  Everyone can upload a demo to the platform

  Scenario: upload a demo
    Given I upload the demo "cmc02gead_16.4.wd10" for player "<acc/RiFo"
    Then I should see "Demo details"
    And I should see /Position.*1st of 1/m
    And I should see /Time.*00:16\.460/m
    And I should see /Map.*cmc02_gead/m
    And I should see /Game.*Warsow 0.4 race/m
    And I should see /Player.*<acc.RiFo/m
    And I should not see "Some information may be wrong!"

  Scenario: upload a demo which is already online
    Given I upload the demo "cmc02gead_16.4.wd10" for player "<acc/RiFo"
    When I go to demo upload
    And I attach "demofiles/cmc02gead_16.4.wd10" to the "demofile[file]" file field
    And I press "Upload"
    Then I should not see "Upload a demo"
    And I should see "Demo details"
    And I should see /Map.*cmc02_gead/m

  Scenario: upload two demos with same file size
    Given I upload the demo "dk-lygdos_12.526.wd10" for player "rlx|Schakal"
    Then I should see "Demo details"
    And I should see /Map.*dk-lygdos/m
    Given I upload the demo "cmc02gead_16.4.wd10" for player "<acc/RiFo"
    Then I should see "Demo details"
    And I should see /Map.*cmc02_gead/m

  Scenario: upload a wd11 race demo
    Given I upload the demo "wd11/race_killua-hykon.wd11"
    Then I should see "Demo details"
    And I should see /Game.*Warsow 0.5 race/m
    And I should see /Map.*killua-hykon/m
    And I should see "-]DvR[-"
    And I should see /Time.*00:16\.500/m

  Scenario: upload a wd11 freestyle demo
    Given I upload the freestyle demo "wd11/freestyle.wd11" with title "laserboost + eb + airrocket = far landing ( using quad )" for players "trx:orb!tal, *korfi"
    Then I should see "Demo details"
    And I should see /Game.*Warsow 0.5 freestyle/m
    And I should see /Map.*ganja-fs1/m
    And I should see /Players.*trx:orb!tal, \*korfi/m
    And I should see /Title.*laserboost \+ eb \+ airrocket = far landing \( using quad \)/m

  Scenario: upload a wd11 freestyle demo without choosing players should not be possible
    Given I upload the freestyle demo "wd11/freestyle.wd11" with title "foo" for players ""
    Then I should not see "Demo details"
    And I should see "Players can't be blank"

  Scenario: upload a dm68 cpm demo
    Given I upload the demo "dm68/pornchronostar_mdf.cpm_00.49.216_tyaz.germany.dm_68"
    Then I should see "Demo details"
    And I should see "Defrag cpm"
    And I should see /Map.*pornchronostar/m
    And I should see "tyaz"
    And I should see /Time.*00:49\.216/m

  Scenario: upload a dm68 vq3 demo
    Given I upload the demo "dm68/runkull2_df.vq3_01.05.904_XunderBIRD.Germany.dm_68"
    Then I should see "Demo details"
    And I should see "Defrag vq3"
    And I should see /Map.*runkull2/m
    And I should see "XunderBIRD"
    And I should see /Time.*01:05\.904/m

