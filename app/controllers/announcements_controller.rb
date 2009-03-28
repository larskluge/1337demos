class AnnouncementsController < ApplicationController
	def simple_list
		@announcements = Announcement.find(:all, :order => 'created_at DESC')
		render :partial => 'simple_list'
	end

  def index
    @announcements = Announcement.paginate(:page => params[:page],
      :per_page => 90,
      :order => 'created_at DESC')

    respond_to do |format|
      # format.html { render :action => 'index' }
      format.atom { render :layout => false }
    end
  end

  def show
    @ann = Announcement.find(params[:id].to_i)
  end
end
