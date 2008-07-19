class ShoutboxesController < ApplicationController

	# caching
	cache_sweeper :shoutbox_sweeper, :only => [:create]

	# GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
	verify :method => :post, :only => [ :destroy, :create, :update ],
				 :redirect_to => { :action => :list }



	def index
		list
		render :action => 'list'
	end

	def list
		@shoutbox_pages, @shoutboxes = paginate :shoutboxes, :per_page => 10
	end

	def show
		@shoutbox = Shoutbox.find(params[:id])
	end

	def new
		@shoutbox = Shoutbox.new
	end

	def create
		@shoutbox = Shoutbox.new(params[:shoutbox])
		if @shoutbox.save
			flash[:notice] = 'Shoutbox was successfully created.'
			redirect_to :controller => 'welcome' #:action => 'list'
		else
			render :action => 'new'
		end
	end
end

