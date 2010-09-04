Feature: shout on main page

  Scenario: shout on main page
    When I go to the homepage
    And I fill in "comment[name]" with "die.viper"
    And I fill in "comment[mail_pass]" with "foobar"
    And I fill in "comment[message]" with "Strange message with umlauts: äöüÄÖÜß"
    And I press "Submit"
    Then I should see /Strange message with umlauts: äöüÄÖÜß.*by\s*die\.viper/m

