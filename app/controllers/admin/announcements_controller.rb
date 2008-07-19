class Admin::AnnouncementsController < ApplicationController
	requires_authentication :using => Proc.new{ |username, password| username == 'admin' && password == 'vip2067' },
													:realm => 'Secret Magic Happy Cloud'

	layout '/admin/application'

	# caching
	cache_sweeper :announcement_sweeper, :only => [:create, :update, :destroy]

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }



  def index
    list
    render :action => 'list'
  end

  def list
    @announcement_pages, @announcements = paginate :announcements, :per_page => 50, :order => 'created_at DESC'
  end

  def show
    @announcement = Announcement.find(params[:id])
  end

  def new
    @announcement = Announcement.new
  end

  def create
    @announcement = Announcement.new(params[:announcement])
    if @announcement.save
      flash[:notice] = 'Announcement was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @announcement = Announcement.find(params[:id])
  end

  def update
    @announcement = Announcement.find(params[:id])
    if @announcement.update_attributes(params[:announcement])
      flash[:notice] = 'Announcement was successfully updated.'
      redirect_to :action => 'show', :id => @announcement
    else
      render :action => 'edit'
    end
  end

  def destroy
    Announcement.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
