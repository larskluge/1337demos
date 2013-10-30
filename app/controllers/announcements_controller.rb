class AnnouncementsController < ApplicationController
	def simple_list
    @announcements = Announcement.order('created_at DESC')
		render :partial => 'simple_list'
	end

  def index
    @announcements = Announcement.order('created_at DESC').page(page_param)

    respond_to do |format|
      format.atom { render :layout => false }
    end
  end

  def show
    @ann = Announcement.find(params[:id])
  end
end

