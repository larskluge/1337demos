class CommentsController < ApplicationController

	caches_action :index, :list

	def index
		list
		render :action => 'list'
	end

	def list
		@comments = Comment.paginate(:page => params[:page], :per_page => 20, :order => 'created_at DESC')
		@title = "latest comments"
	end
end
