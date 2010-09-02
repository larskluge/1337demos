require 'digest/sha1'

class Stuff < ActiveRecord::Base

  has_attached_file :stuff_file
  validates_attachment_presence :stuff_file
  validates_attachment_size :stuff_file, :in => 1.byte..5.megabytes

  has_many :comments, :as => :commentable, :dependent => :destroy, :order => 'created_at ASC'



  before_validation :generate_sha1, :on => :create

  validates_presence_of :sha1
  validates_uniqueness_of :sha1, :message => "File was already uploaded."



  def comment_attributes=(hash)
    comments.build(hash)
  end

  def comment
    comments.first
  end



	def generate_sha1
		self.sha1 = Digest::SHA1.hexdigest(stuff_file.to_file.open.gets(nil)) if stuff_file?
	end
end

