class Admin::DemosController < Admin::ApplicationController

	# caching
	cache_sweeper :demo_sweeper, :only => [:create, :update, :destroy]



	def index
		list
		render :action => 'list'
	end

	def list
		@demos = Demo.paginate(:page => params[:page],
			:per_page => 50, :order => 'updated_at DESC')
	end

	def show
		@demo = Demo.find(params[:id])
	end

	def new
		@demo = Demo.new
	end

	def create
		@demo = Demo.new(params[:demo])
		if @demo.save
			flash[:notice] = 'Demo was successfully created.'
			redirect_to :action => 'list'
		else
			render :action => 'new'
		end
	end

	def edit
		@demo = Demo.find(params[:id])
	end

	def update
		@demo = Demo.find(params[:id])
		if @demo.update_attributes(params[:demo])
			flash[:notice] = 'Demo was successfully updated.'
			redirect_to :action => 'show', :id => @demo
		else
			render :action => 'edit'
		end
	end

	def destroy
		Demo.find(params[:id]).destroy
		redirect_to :action => 'list'
	end
end
