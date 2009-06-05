class Comment < ActiveRecord::Base
  attr_accessor :passphrase



	belongs_to :commentable, :polymorphic => :true



	validates_presence_of :message, :name
  validates_length_of :message, :maximum => 255
  validate :prevent_url_posting

	validates_presence_of :mail_pass

  validates_length_of :passphrase, :in => 6..255, :on => :create, :if => :passphrase_given?

  validates_length_of :mail, :in => 5..255, :if => :mail_given?
  validates_format_of :mail, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :if => :mail_given?



  is_gravtastic :mail_pass

  def has_gravatar?
    !!mail_pass
  end



	def demo
		return nil if self.commentable_type != 'Demo'
		return @demo if !@demo.nil?

		@demo = Demo.find(self.commentable_id)
		return @demo
	end



  def mail_pass
    mail || passphrase || token
  end

  def mail_pass=(str)
    if str =~ /@/
      self.mail = str
    else
      self.passphrase = str
      self.token = Digest::MD5.hexdigest(self.passphrase) if passphrase.respond_to?('empty?') && !passphrase.empty?
    end
  end

  def mail_given?
    !!mail
  end

  def passphrase_given?
    !!@passphrase || !!@token
  end

  def token_short
    self.token[0..7] if token
  end



  protected

  def prevent_url_posting
    if message =~ /[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,6}/
      errors.add_to_base("No urls allowed")
    end
  end

end

