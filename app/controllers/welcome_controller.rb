class WelcomeController < ApplicationController

	caches_action :index, :cache_path => :cache_path.to_proc


	def index
		@title = ''
		@announcements = Announcement.find(:all, :order => 'created_at DESC')
		@shoutboxes = Shoutbox.paginate(:page => params[:page], :per_page => 5, :order => 'created_at DESC')
	end


end

