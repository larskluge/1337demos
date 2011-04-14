class User < ActiveRecord::Base
  include Gravtastic

  MAIL_REGEXP = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  has_many :comments

  attr_accessible :name, :mail_pass

  validates_presence_of :name
  validates_length_of :mail, :in => 5..255, :allow_nil => true
  validates_format_of :mail, :with => MAIL_REGEXP, :allow_nil => true
  validates_length_of :passphrase, :in => 6..255, :on => :create

  scope :approved, where(:approved => true)

  gravtastic :mail_pass


  def self.find_by_name_and_unencrypted_passphrase(name, unencrypted_passphrase)
    find_by_name_and_passphrase(name, encrypt_passphrase(unencrypted_passphrase))
  end

  def mail_pass
    @mail_pass || mail || passphrase
  end

  def mail_pass=(val)
    self.mail = val if val =~ MAIL_REGEXP
    self.passphrase = self.class.encrypt_passphrase(val) if val.present?
    @mail_pass = val
  end

  def has_gravatar?
    mail_pass.present?
  end

  def approved?
    approved
  end

  def approve!
    self.approved = true
    save!
  end


  protected

  def self.encrypt_passphrase(unencrypted_passphrase)
    Digest::MD5.hexdigest(unencrypted_passphrase)
  end

end

