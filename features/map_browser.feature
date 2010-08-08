Feature: Map browser

  Background: some maps are uploaded
    Given I upload the demo "cmc02gead_16.4.wd10" for player "<acc/RiFo"
    And I upload the demo "dk-lygdos_12.526.wd10" for player "rlx|Schakal"
    And I upload the demo "wd11/race_killua-hykon.wd11"

  Scenario: show maps in the map browser
    When I go to the map browser
    Then I should see "Listing maps"
    And I should not see "No maps found."

  Scenario: show first page when page param is broken
    When I go to the map browser on a broken page
    Then I should see "Listing maps"

  Scenario: search for a map and view detail page
    When I go to the map browser
    Then I should see "Listing maps"
    When I fill in "mapsearch" with "cmc"
    And I press "Search"
    Then I should see "cmc02_gead"
    And I follow "cmc02_gead"
    And I should see /#1.*RiFo.*Play/

