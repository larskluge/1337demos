require 'demo_reader'

class TestsController < ApplicationController
	#SYS_DEMOFILES = RAILS_ROOT + '/public/demofiles/'
	SYS_DEMOFILES = RAILS_ROOT + '/data/test_demos/warsow_0.4/'


	def index

	end

	def list_demos
		files = Dir.glob(SYS_DEMOFILES + '**/*.wd*')
		@drs = files.collect{ |file| DemoReader.new file }

		render :layout => false
	end
end
