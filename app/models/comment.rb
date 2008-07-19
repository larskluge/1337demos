class Comment < ActiveRecord::Base
	belongs_to :commentable, :polymorphic => :true

	validates_presence_of :name, :message

	def demo()
		return null if self.commentable_type != 'Demo'
		return @demo if !@demo.nil?

		@demo = Demo.find(self.commentable_id)
		return @demo
	end
end
