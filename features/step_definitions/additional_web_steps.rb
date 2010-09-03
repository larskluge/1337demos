
When /^I attach "([^"]*)" to the "([^"]*)" file field$/ do |filename, field|
  attach_file field, File.join(RAILS_ROOT, "test/assets", filename)
end

Then /^I debug$/ do
  breakpoint
  0
end

