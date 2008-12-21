class Admin::AnnouncementsController < Admin::ApplicationController

	# caching
	cache_sweeper :announcement_sweeper, :only => [:create, :update, :destroy]

  active_scaffold :announcement do |opts|
    list.per_page = 50
    list.sorting = {:created_at => 'DESC'}
  end



	# def index
	# 	@announcements = Announcement.paginate(:page => params[:page],
	# 		:per_page => 50, :order => 'created_at DESC')
	# 	render :action => 'list'
	# end

	# def show
	# 	@announcement = Announcement.find(params[:id])
	# end

	# def new
	# 	@announcement = Announcement.new
	# end

	# def create
	# 	@announcement = Announcement.new(params[:announcement])
	# 	if @announcement.save
	# 		flash[:notice] = 'Announcement was successfully created.'
	# 		redirect_to :action => 'index'
	# 	else
	# 		render :action => 'new'
	# 	end
	# end

	# def edit
	# 	@announcement = Announcement.find(params[:id])
	# end

	# def update
	# 	@announcement = Announcement.find(params[:id])
	# 	if @announcement.update_attributes(params[:announcement])
	# 		flash[:notice] = 'Announcement was successfully updated.'
	# 		redirect_to :action => 'show', :id => @announcement
	# 	else
	# 		render :action => 'edit'
	# 	end
	# end

	# def destroy
	# 	Announcement.find(params[:id]).destroy
	# 	redirect_to :action => 'index'
	# end
end

