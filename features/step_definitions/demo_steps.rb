Given /^I upload the demo "([^\"]*)" for player "([^\"]*)"$/ do |demo, player|
  When "I go to demo upload"
  When %Q{I attach "demofiles/#{demo}" to the "demofile[file]" file field}
  When %Q{I press "Upload"}
  Then %Q{I should see "Verify information"}
  When %Q{I select "#{player}" from "demo[players]"}
  When %Q{I choose "yes"}
  When %Q{I press "Submit"}
end

Given /^I upload the demo "([^\"]*)"$/ do |demo|
  When "I go to demo upload"
  When %Q{I attach "demofiles/#{demo}" to the "demofile[file]" file field}
  When %Q{I press "Upload"}
  Then %Q{I should see "Verify information"}
  Then %Q{I choose "yes"}
  Then %Q{I press "Submit"}
end

Given /^I upload the freestyle demo "([^\"]*)" with title "([^\"]*)" for players "([^\"]*)"$/ do |demo, title, players|
  When %Q{I go to demo upload}
  When %Q{I attach "demofiles/#{demo}" to the "demofile[file]" file field}
  When %Q{I press "Upload"}
  Then %Q{I should see "Verify information"}
  Then %Q{I fill in "Title" with "#{title}"}
  Then %Q{I choose "yes"}

  players.split(",").each do |player|
    Then "I check \"#{player.strip}\""
  end

  Then 'I press "Submit"'
end

