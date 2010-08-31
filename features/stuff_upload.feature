Feature: Upload stuff
  Anyone can upload stuff to the platform

  Scenario: upload stuff
    When I go to the stuff upload
    And I fill in "stuff[comment_attributes][name]" with "die.viper"
    And I fill in "stuff[comment_attributes][mail]" with "foo@bar.com"
    And I fill in "stuff[comment_attributes][message]" with "important message"
    And I attach "stuffs/viper.png" to the "stuff[stuff_file]" file field
    And I press "Upload"
    Then I should see "Thanks"

  Scenario: upload stuff without attachment should not break
    When I go to the stuff upload
    And I fill in "stuff[comment_attributes][name]" with "die.viper"
    And I fill in "stuff[comment_attributes][mail]" with "foo@bar.com"
    And I fill in "stuff[comment_attributes][message]" with "important message"
    And I press "Upload"
    Then I should see "file name must be set"

