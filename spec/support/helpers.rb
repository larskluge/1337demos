module Helpers

  def upload_demo path, opts = nil, &block
    opts ||= {}
    player = opts[:for]
    verify = if opts[:verify] == false then false else true end

    visit new_demofile_path
    attach_file 'demofile[file]', Rails.root.join("test/assets/demofiles/#{path}")
    click_button 'Upload'
    if verify
      expect(page).to have_content('Verify information')
      select player if player
      choose 'yes'
      yield if block
      click_on 'Submit'
    end
  end

end

