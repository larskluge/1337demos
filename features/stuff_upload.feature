Feature: Upload stuff
  Anyone can upload stuff to the platform

  Scenario: upload stuff
    When I go to the stuff upload
    And I fill in "stuff[comments_attributes][0][user_attributes][name]" with "die.viper"
    And I fill in "stuff[comments_attributes][0][user_attributes][mail_pass]" with "foo@bar.com"
    And I fill in "stuff[comments_attributes][0][message]" with "important message"
    And I attach "stuffs/viper.png" to the "stuff[stuff_file]" file field
    And I press "Upload"
    Then I should see "Thanks"

  Scenario: upload stuff without attachment should not break
    When I go to the stuff upload
    And I fill in "stuff[comments_attributes][0][user_attributes][name]" with "die.viper"
    And I fill in "stuff[comments_attributes][0][user_attributes][mail_pass]" with "foo@bar.com"
    And I fill in "stuff[comments_attributes][0][message]" with "important message"
    And I press "Upload"
    Then I should see "Stuff file can't be blank"

