
When /^I attach "([^"]*)" to the "([^"]*)" file field$/ do |filename, field|
  attach_file field, File.join(Rails.root, "test/assets", filename)
end

Then /^I debug$/ do
  breakpoint
  0
end

Then /^(?:|I )should see \/([^\/]*)\/m(?: within "([^"]*)")?$/ do |regexp, selector|
  regexp = Regexp.new(regexp, Regexp::MULTILINE)
  with_scope(selector) do
    if page.respond_to? :should
      page.should have_xpath('//*', :text => regexp)
    else
      assert page.has_xpath?('//*', :text => regexp)
    end
  end
end

# this is a hack coz page.check is not working for labels with text in child spans
#
When /^I check via input value "([^"]*)"$/ do |value|
  page.find(:css, "input[value='#{value}']").set(true)
end

