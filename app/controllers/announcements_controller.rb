class AnnouncementsController < ApplicationController
	def simple_list
		@announcements = Announcement.find(:all, :order => 'created_at DESC')
		render :partial => 'simple_list'
	end
end
