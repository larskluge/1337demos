Given /^I upload the demo "([^\"]*)" for player "([^\"]*)"$/ do |demo, player|
  step "I go to demo upload"
  step %Q{I attach "demofiles/#{demo}" to the "demofile[file]" file field}
  step %Q{I press "Upload"}
  step %Q{I should see "Verify information"}
  step %Q{I select "#{player}" from "demo[players]"}
  step %Q{I choose "yes"}
  step %Q{I press "Submit"}
end

Given /^I upload the demo "([^\"]*)"$/ do |demo|
  step "I go to demo upload"
  step %Q{I attach "demofiles/#{demo}" to the "demofile[file]" file field}
  step %Q{I press "Upload"}
  step %Q{I should see "Verify information"}
  step %Q{I choose "yes"}
  step %Q{I press "Submit"}
end

Given /^I upload the freestyle demo "([^\"]*)" with title "([^\"]*)" for players "([^\"]*)"$/ do |demo, title, players|
  step %Q{I go to demo upload}
  step %Q{I attach "demofiles/#{demo}" to the "demofile[file]" file field}
  step %Q{I press "Upload"}
  step %Q{I should see "Verify information"}
  step %Q{I fill in "Title" with "#{title}"}
  step %Q{I choose "yes"}

  players.split(",").each do |player|
    step "I check \"#{player.strip}\""
  end

  step 'I press "Submit"'
end

