Feature: Upload a demo
  Anyone can upload a demo to the platform

  Scenario: upload a demo
    Given I upload the demo "cmc02gead_16.4.wd10" for player "<acc/RiFo"
    Then I should see "Demo details"
    And I should see /Position.*1st of 1/
    And I should see /Time.*16.460/
    And I should see /Map.*cmc02_gead/
    And I should see /Game.*Warsow 0.4 race/
    And I should see /Player.*<acc\/RiFo/
    And I should not see "Some information may be wrong!"

  Scenario: upload a demo which is already online
    Given I upload the demo "cmc02gead_16.4.wd10" for player "<acc/RiFo"
    When I go to demo upload
    And I attach "demofiles/cmc02gead_16.4.wd10" to the "demofile[uploaded_data]" file field
    And I press "Upload"
    Then I should not see "Upload a demo"
    And I should see "Demo details"
    And I should see /Map.*cmc02_gead/

  Scenario: upload two demos with same file size
    Given I upload the demo "dk-lygdos_12.526.wd10" for player "rlx|Schakal"
    Then I should see "Demo details"
    And I should see /Map.*dk-lygdos/
    Given I upload the demo "cmc02gead_16.4.wd10" for player "<acc/RiFo"
    Then I should see "Demo details"
    And I should see /Map.*cmc02_gead/

  Scenario: upload a wd11 demo
    Given I upload the demo "wd11/race_killua-hykon.wd11"
    Then I should see "Demo details"
    And I should see /Map.*killua-hykon/
    And I should see "-]DvR[-"
  Scenario: upload a wd11 freestyle demo
    Given I upload the freestyle demo "wd11/freestyle.wd11" with title "laserboost + eb + airrocket = far landing ( using quad )" for players "trx:orb!tal, *korfi"
    Then I should see "Demo details"
    And I should see /Game.*Warsow 0.5 freestyle/
    And I should see /Map.*ganja-fs1/
    And I should see /Players.*trx:orb!tal, \*korfi/
    And I should see /Title.*laserboost \+ eb \+ airrocket = far landing \( using quad \)/

  Scenario: upload a wd11 freestyle demo without choosing players should not be possible
    Given I upload the freestyle demo "wd11/freestyle.wd11" with title "foo" for players ""
    Then I should not see "Demo details"
    And I should see "Players can't be blank"


