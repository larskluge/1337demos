Feature: shout on main page

  Scenario: shout by not approved user
    When I go to the homepage
    And I fill in "comment[user_attributes][name]" with "die.viper"
    And I fill in "comment[user_attributes][mail_pass]" with "foobar"
    And I fill in "comment[message]" with "hello world!"
    And I press "Submit"
    Then I should not see /hello world!/

  Scenario: shout by approved user
    When I am the approved user "die.viper" with passphrase "foobar"
    And I go to the homepage
    And I fill in "comment[user_attributes][name]" with "die.viper"
    And I fill in "comment[user_attributes][mail_pass]" with "foobar"
    And I fill in "comment[message]" with "hello world!"
    And I press "Submit"
    Then I should see /hello world!/

  Scenario: unapproved, approved and show behavior of posting messages
    When I go to the homepage
    And I fill in "comment[user_attributes][name]" with "die.viper"
    And I fill in "comment[user_attributes][mail_pass]" with "foobar"
    And I fill in "comment[message]" with "hello world!"
    And I press "Submit"
    Then I should not see /hello world!/
    Then I approve the user "die.viper" with passphrase "foobar"
    Then I go to the homepage
    And I fill in "comment[user_attributes][name]" with "die.viper"
    And I fill in "comment[user_attributes][mail_pass]" with "foobar"
    And I fill in "comment[message]" with "hello world2!"
    And I press "Submit"
    Then I should see /hello world!/
    Then I should see /hello world2!/

  Scenario: shout with umlauts
    When I am the approved user "die.viper" with passphrase "foobar"
    And I go to the homepage
    And I fill in "comment[user_attributes][name]" with "die.viper"
    And I fill in "comment[user_attributes][mail_pass]" with "foobar"
    And I fill in "comment[message]" with "Strange message with umlauts: äöüÄÖÜß"
    And I press "Submit"
    Then I should see /Strange message with umlauts: äöüÄÖÜß.*by\s*die\.viper/m

