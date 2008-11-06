class Comment < ActiveRecord::Base
	belongs_to :commentable, :polymorphic => :true

	validates_presence_of :name, :message

	def demo
		return null if self.commentable_type != 'Demo'
		return @demo if !@demo.nil?

		@demo = Demo.find(self.commentable_id)
		return @demo
	end

  def passphrase
    nil
  end

  def passphrase=(pass)
    self.token = Digest::MD5.hexdigest(pass) if pass.respond_to?('empty?') && !pass.empty?
  end

  def token_short
    self.token[0..7] if token
  end
end
