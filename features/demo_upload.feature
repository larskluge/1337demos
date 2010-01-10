Feature: Upload a demo
  Anyone can upload a demo to the platform

  Scenario: upload a demo
    When I go to demo upload
    And I attach "cmc02gead_16.4.wd10" to the "demofile[uploaded_data]" file field
    And I press "Upload"
    Then I should see "Verify information"
    When I select "<acc/RiFo" from "demo[players]"
    And I choose "yes"
    And I press "Submit"
    Then I should see "Demo details"
    And I should see /Position.*1st of 1/
    And I should see /Time.*16.460/
    And I should see /Map.*cmc02_gead/
    And I should see /Gamemode.*race/
    And I should see /Player.*<acc\/RiFo/
    And I should not see "Some information may be wrong!"

