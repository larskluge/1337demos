class CommentsController < ApplicationController

	def index
		@comments = Comment.demo.approved.order('created_at DESC').page(page_param).per(20)
		@title = "latest comments"
	end

end

