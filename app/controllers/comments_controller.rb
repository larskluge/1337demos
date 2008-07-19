class CommentsController < ApplicationController

	caches_action :index, :list

	def index
		list
		render :action => 'list'
	end

	# GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
	verify :method => :post, :only => [ :create ],
				 :redirect_to => { :action => :list }

	def list
		@comments = Comment.paginate(:page => params[:page], :per_page => 20, :order => 'created_at DESC')
		@title = "latest comments"
	end
end
