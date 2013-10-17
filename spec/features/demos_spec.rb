require 'spec_helper'

describe 'Demos', vcr: true, match_requests_on: [:body] do

  before do
    upload_demo 'cmc02gead_16.4.wd10', for: '<acc/RiFo'
  end

  it 'views demos overview page' do
    visit demos_path
    expect(page).to have_content('All Demos')
    click_on 'Play'
    expect(page).to have_content('Demo details')
  end

  it 'adds a comment to a demo' do
    visit demo_path(Demo.last.id)
    expect(page).to have_content('Demo details')
    user = User.create!(name: 'die.viper', mail_pass: 'foobar')
    user.approve!
    fill_in 'Your name', with: 'die.viper'
    fill_in 'Mail for', with: 'foobar'
    fill_in 'Message', with: 'this is a comment'
    click_on 'Submit'
    expect(page).to have_content(/this is a comment.*by die.viper/m)

    visit comments_path
    expect(page).to have_content(/this is a comment/)
  end

  it 'tries to add a spam comment' do
    visit demo_path(Demo.last.id)
    expect(page).to have_content('Demo details')
    fill_in 'Your name', with: 'spammer'
    fill_in 'Mail for', with: 'foobar'
    fill_in 'Message', with: 'this is spam'
    click_on 'Submit'
    expect(page).to have_no_content(/this is spam/)

    visit comments_path
    expect(page).to have_no_content(/this is spam/)
  end

  it 'loads atom feed' do
    Demo.last.update_attribute(:status, :rendered)
    visit demos_path(format: :atom)
    expect(page).to have_css('entry', count: 1)
  end

end

