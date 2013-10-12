require 'spec_helper'

describe 'Maps', vcr: true, match_requests_on: [:body] do

  before do
    upload_demo 'cmc02gead_16.4.wd10', for: '<acc/RiFo'
    upload_demo 'dk-lygdos_12.526.wd10', for: 'rlx|Schakal'
    upload_demo 'wd11/race_killua-hykon.wd11'
  end

  it 'shows all maps' do
    visit maps_path
    expect(page).to have_content('Listing maps')
    expect(page).to have_no_content('No maps found')
    expect(page).to have_css('.map_image_thumb', count: 3)
  end

  it 'shows first page when page parameter is invalid' do
    visit maps_path(page: 'foo')
    expect(page).to have_content('Listing maps')
    expect(page).to have_css('.map_image_thumb', count: 3)
  end

  it 'searchs for a map' do
    visit maps_path
    fill_in 'mapsearch', with: 'cmc'
    click_on 'Search'
    expect(page).to have_css('.map_image_thumb', count: 1)
    expect(page).to have_content('cmc02_gead')
  end

end

