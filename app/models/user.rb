class User < ActiveRecord::Base
  include Gravtastic

  MAIL_REGEXP = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  attr_accessible :name, :mail_pass

  validates_presence_of :name
  validates_length_of :mail, :in => 5..255, :allow_nil => true
  validates_format_of :mail, :with => MAIL_REGEXP, :allow_nil => true
  validates_length_of :passphrase, :in => 6..255, :on => :create

  gravtastic :mail_pass


  def mail_pass
    @mail_pass || mail || passphrase
  end

  def mail_pass=(val)
    self.mail = val if val =~ MAIL_REGEXP
    self.passphrase = Digest::MD5.hexdigest(val) if val.present?
    @mail_pass = val
  end

  def has_gravatar?
    mail_pass.present?
  end

end

