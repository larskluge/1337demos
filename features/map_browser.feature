Feature: Map browser

  Scenario: show first page when page param is broken
    When I go to the map browser on a broken page
    Then I should see "Listing maps"

  Scenario: search for a map and view detail page
    Given I upload the demo "cmc02gead_16.4.wd10" for player "<acc/RiFo"
    When I go to the map browser
    Then I should see "Listing maps"
    When I fill in "mapsearch" with "cmc"
    And I press "Search"
    Then I should see "cmc02_gead"
    And I follow "cmc02_gead"
    And I should see /#1.*RiFo.*Play/

