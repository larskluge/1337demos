Then /^I approve the user "([^"]*)" with passphrase "([^"]*)"$/ do |name, passphrase|
  User.find_by_name_and_unencrypted_passphrase(name, passphrase).approve!
end

When /^I am the approved user "([^"]*)" with passphrase "([^"]*)"$/ do |name, passphrase|
  user = User.create!(:name => name, :mail_pass => passphrase)
  user.approve!
end


