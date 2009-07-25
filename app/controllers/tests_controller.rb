require 'demo_reader'

class TestsController < ApplicationController
	# SYS_DEMOFILES = RAILS_ROOT + '/data/test_demos/'
	# SYS_DEMOFILES = File.join(Rails.root, '../interessting_demos')
	SYS_DEMOFILES = File.join(Rails.root, '../interessting_demos/defrag')


	def list_demos
		files = Dir.glob(File.join(SYS_DEMOFILES, '**', '*.wd*'))
		@drs = files.collect{ |file| DemoReaderWarsow.new file }

		files = Dir.glob(File.join(SYS_DEMOFILES, '**', '*.dm_*'))
		@drs += files.collect{ |file| DemoReaderDefrag.new file }

		render :layout => false
	end
end

