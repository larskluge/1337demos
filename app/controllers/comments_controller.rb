class CommentsController < ApplicationController

	def index
		@comments = Comment.demo.approved.paginate(:page => page_param, :per_page => 20, :order => 'created_at DESC')
		@title = "latest comments"
	end

end

