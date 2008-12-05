class Comment < ActiveRecord::Base
	belongs_to :commentable, :polymorphic => :true

	validates_presence_of :message, :name
  validates_length_of :message, :maximum => 255
  validate :prevent_url_posting

	validates_presence_of :passphrase, :on => :create
  validates_length_of :passphrase, :minimum => 6, :on => :create

  def prevent_url_posting
    if message =~ /[a-zA-Z0-9\-\.]+\.(com|edu|gov|mil|net|org|biz|info|name|museum|us|ca|uk|de)/
      errors.add_to_base("No urls allowed")
    end
  end





	def demo
		return null if self.commentable_type != 'Demo'
		return @demo if !@demo.nil?

		@demo = Demo.find(self.commentable_id)
		return @demo
	end

  def passphrase
    @passphrase
  end

  def passphrase=(pass)
    @passphrase = pass
    self.token = Digest::MD5.hexdigest(pass) if pass.respond_to?('empty?') && !pass.empty?
  end

  def token_short
    self.token[0..7] if token
  end
end
