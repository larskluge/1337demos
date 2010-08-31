require 'digest/sha1'

class Stuff < ActiveRecord::Base

  has_attachment :storage => :file_system, :size => 1.byte..5.megabytes

  has_attached_file :stuff_file
  validates_attachment_presence :stuff_file
  validates_attachment_size :stuff_file, :in => 1.byte..5.megabytes

  has_many :comments, :as => :commentable, :dependent => :destroy, :order => 'created_at ASC'



  before_validation_on_create :generate_sha1

  validates_presence_of :sha1
  validates_uniqueness_of :sha1, :message => "File was already uploaded."



  def comment_attributes=(hash)
    comments.build(hash)
  end

  def comment
    comments.first
  end



	def generate_sha1
		self.sha1 = Digest::SHA1.hexdigest(temp_data) if temp_data.present?
	end
end

