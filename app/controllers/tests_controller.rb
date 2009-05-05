require 'demo_reader'

class TestsController < ApplicationController
	# SYS_DEMOFILES = RAILS_ROOT + '/data/test_demos/'
	SYS_DEMOFILES = File.join(Rails.root, '../interessting_demos')


	def list_demos
		files = Dir.glob(File.join(SYS_DEMOFILES, '**', '*.wd*'))
		@drs = files.collect{ |file| DemoReader.new file }

		render :layout => false
	end
end
