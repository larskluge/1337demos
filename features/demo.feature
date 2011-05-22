Feature: Browse on demo lists and detail pages

  Background:
    Given I upload the demo "cmc02gead_16.4.wd10" for player "<acc/RiFo"

  Scenario: go to demo detail page
    When I go to demos overview
    Then I should see "Latest demos"
    When I follow "Play"
    Then I should see "Demo details"

  Scenario: make a comment on demo detail page
    When I go to demos overview
    Then I should see "Latest demos"
    When I follow "Play"
    Then I should see "Demo details"
    When I am the approved user "die.viper" with passphrase "foobar"
    And I fill in "comment[user_attributes][name]" with "die.viper"
    And I fill in "comment[user_attributes][mail_pass]" with "foobar"
    And I fill in "comment[message]" with "hello world!"
    And I press "Submit"
    Then I should see /hello world!/
    When I go to comments overview
    Then I should see /hello world!/

  Scenario: make a spam comment on demo detail page
    When I go to demos overview
    Then I should see "Latest demos"
    When I follow "Play"
    Then I should see "Demo details"
    And I fill in "comment[user_attributes][name]" with "spamer"
    And I fill in "comment[user_attributes][mail_pass]" with "foobar"
    And I fill in "comment[message]" with "some spam comment"
    And I press "Submit"
    Then I should not see "some spam comment"
    When I go to comments overview
    Then I should not see "some spam comment"

