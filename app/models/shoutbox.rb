class Shoutbox < ActiveRecord::Base
	validates_presence_of :name, :message
  validates_length_of :message, :maximum => 255
  validate :prevent_url_posting

  def prevent_url_posting
    if message =~ /[a-zA-Z0-9\-\.]+\.(com|edu|gov|mil|net|org|biz|info|name|museum|us|ca|uk|de)/
      errors.add_to_base("No urls allowed")
    end
  end

end
