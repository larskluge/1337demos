class WelcomeController < ApplicationController

	caches_action :index

	def index
		@announcements = Announcement.find(:all, :order => 'created_at DESC')
		@shoutboxes = Shoutbox.paginate(:page => params[:page], :per_page => 5, :order => 'created_at DESC')
	end
end

