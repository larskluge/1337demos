class AnnouncementsController < ApplicationController
	def simple_list
    @announcements = Announcement.order('created_at DESC')
		render :partial => 'simple_list'
	end

  def index
    @announcements = Announcement.order('created_at DESC').paginate(
      :page => page_param,
      :per_page => 20)

    respond_to do |format|
      format.atom { render :layout => false }
    end
  end

  def show
    @ann = Announcement.find(params[:id])
  end
end

