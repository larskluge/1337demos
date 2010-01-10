Given /^I upload the demo "([^\"]*)" for player "([^\"]*)"$/ do |demo, player|
  steps %Q{
    When I go to demo upload
    And I attach "demofiles/#{demo}" to the "demofile[uploaded_data]" file field
    And I press "Upload"
    Then I should see "Verify information"
    When I select "#{player}" from "demo[players]"
    And I choose "yes"
    And I press "Submit"
  }
end

