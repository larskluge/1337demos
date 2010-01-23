Feature: Map browser

  Scenario: show first page when page param is broken
    When I go to the map browser on a broken page
    Then I should see "Listing maps"

