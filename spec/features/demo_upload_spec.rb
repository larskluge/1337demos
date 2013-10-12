require 'spec_helper'

describe 'Demo Upload' do

  it 'uploads a demo', :vcr do
    visit new_demofile_path
    attach_file 'demofile[file]', Rails.root.join('test/assets/demofiles/cmc02gead_16.4.wd10')
    click_button 'Upload'
    expect(page).to have_content('Verify information')
    select '<acc/RiFo'
    choose 'yes'
    click_on 'Submit'
    expect(page).to have_content('Demo details')
    expect(page).to have_content(/Position.*1st of 1/m)
    expect(page).to have_content(/Time.*00:16\.460/m)
    expect(page).to have_content(/Map.*cmc02_gead/m)
    expect(page).to have_content(/Game.*Warsow 0.4 race/m)
    expect(page).to have_content(/Player.*<acc.RiFo/m)
    expect(page).not_to have_content('Some information may be wrong!')
  end

end

