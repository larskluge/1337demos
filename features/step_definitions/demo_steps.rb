Given /^I upload the demo "([^\"]*)" for player "([^\"]*)"$/ do |demo, player|
  steps %Q{
    When I go to demo upload
    And I attach "demofiles/#{demo}" to the "demofile[file]" file field
    And I press "Upload"
    Then I should see "Verify information"
    When I select "#{player}" from "demo[players]"
    And I choose "yes"
    And I press "Submit"
  }
end

Given /^I upload the demo "([^\"]*)"$/ do |demo|
  steps %Q{
    When I go to demo upload
    And I attach "demofiles/#{demo}" to the "demofile[file]" file field
    And I press "Upload"
    Then I should see "Verify information"
    And I choose "yes"
    And I press "Submit"
  }
end

Given /^I upload the freestyle demo "([^\"]*)" with title "([^\"]*)" for players "([^\"]*)"$/ do |demo, title, players|
  steps %Q{
    When I go to demo upload
    And I attach "demofiles/#{demo}" to the "demofile[file]" file field
    And I press "Upload"
    Then I should see "Verify information"
    And I fill in "Title" with "#{title}"
    And I choose "yes"
  }

  players.split(",").each do |player|
    Then "I check \"#{player.strip}\""
  end

  Then 'I press "Submit"'
end

