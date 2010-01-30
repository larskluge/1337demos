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

