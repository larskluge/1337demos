require 'digest/md5'

class Stuff < ActiveRecord::Base

	has_attachment :storage => :file_system, :size => 1.byte..5.megabytes
	validates_as_attachment

  has_many :comments, :as => :commentable, :dependent => :destroy, :order => 'created_at ASC'



  before_save :generate_md5



	def validate
    errors.add_to_base 'File was already uploaded.' if Stuff.find_by_md5_and_size(self.md5 || self.generate_md5, self.size)
	end


  def comment_attributes=(hash)
    comments.build(hash)
  end

  def comment
    comments.first
  end



	def generate_md5
		return false if !size || !temp_data;

		self.md5 = Digest::MD5.hexdigest(self.temp_data)
	end
end

