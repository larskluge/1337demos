
When /^I attach "([^\"]*)" to the "([^\"]*)" file field$/ do |filename, field|
  type = "application/octet-stream"
  attach_file field, File.join(RAILS_ROOT, "test/assets", filename), type
end

