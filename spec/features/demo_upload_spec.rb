require 'spec_helper'

describe 'Demo Upload', vcr: true, match_requests_on: [:body] do

  it 'uploads a race demo' do
    upload_demo 'cmc02gead_16.4.wd10', for: '<acc/RiFo'
    expect(page).to have_content('Demo details')
    expect(page).to have_content(/Position.*1st of 1/m)
    expect(page).to have_content(/Time.*00:16\.460/m)
    expect(page).to have_content(/Map.*cmc02_gead/m)
    expect(page).to have_content(/Game.*Warsow 0.4 race/m)
    expect(page).to have_content(/Player.*<acc.RiFo/m)
    expect(page).not_to have_content('Some information may be wrong!')
  end

  it 'uploads the same demo twice' do
    upload_demo 'cmc02gead_16.4.wd10', for: '<acc/RiFo'
    upload_demo 'cmc02gead_16.4.wd10', verify: false
    expect(page).to have_no_content('Upload a demo')
    expect(page).to have_no_content('Verify information')
    expect(page).to have_content('Demo details')
    expect(page).to have_content(/Player.*<acc.RiFo/m)
  end

  it 'uploads two demos with same file size' do
    upload_demo 'dk-lygdos_12.526.wd10', for: 'rlx|Schakal'
    expect(page).to have_content('Demo details')
    expect(page).to have_content(/Map.*dk-lygdos/m)
    upload_demo 'cmc02gead_16.4.wd10', for: '<acc/RiFo'
    expect(page).to have_content('Demo details')
    expect(page).to have_content(/Map.*cmc02_gead/m)
  end

  it 'uploads a freestyle demo' do
    upload_demo 'wd11/freestyle.wd11' do
      find(:css, 'input[value="^0trx^2:^0orb!tal"]').set(true)
      find(:css, 'input[value="^7*^0k^7o^0r^7f^0i"]').set(true)
      fill_in 'Title', with: 'laserboost + eb + airrocket = far landing ( using quad )'
    end
    expect(page).to have_content('Demo details')
    expect(page).to have_content(/Game.*Warsow 0.5 freestyle/m)
    expect(page).to have_content(/Map.*ganja-fs1/m)
    expect(page).to have_content(/Players.*trx:orb!tal, \*korfi/m)
    expect(page).to have_content(/Title.*laserboost \+ eb \+ airrocket = far landing \( using quad \)/m)
  end

  it 'fails to upload a freestyle demo without choosing players' do
    upload_demo 'wd11/freestyle.wd11' do
      fill_in 'Title', with: 'foo'
    end
    expect(page).to have_no_content('Demo details')
    expect(page).to have_content("Players can't be blank")
  end

  it 'uploads a dm68 cpm demo' do
    upload_demo 'dm68/pornchronostar_mdf.cpm_00.49.216_tyaz.germany.dm_68'
    expect(page).to have_content('Demo details')
    expect(page).to have_content(/Game.*Defrag cpm/m)
    expect(page).to have_content(/Player.*tyaz/m)
  end

  it 'uploads a dm68 vq3 demo' do
    upload_demo 'dm68/runkull2_df.vq3_01.05.904_XunderBIRD.Germany.dm_68'
    expect(page).to have_content('Demo details')
    expect(page).to have_content(/Game.*Defrag vq3/m)
    expect(page).to have_content(/Player.*XunderBIRD/m)
  end

  it 'uploads a dm68 demo with multiple finish times' do
    upload_demo 'dm68/mega_wood[mdf.cpm]00.14.752(kreator.Germany).dm_68'
    expect(page).to have_content('Demo details')
    expect(page).to have_content(/Time.*00:14\.752/m)
  end

end

