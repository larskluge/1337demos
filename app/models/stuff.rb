require 'digest/sha1'

class Stuff < ActiveRecord::Base
  attr_accessible :comments_attributes, :stuff_file

  has_attached_file :stuff_file
  validates_attachment_presence :stuff_file
  validates_attachment_size :stuff_file, :in => 1.byte..10.megabytes

  has_many :comments, :as => :commentable, :dependent => :destroy, :order => 'created_at ASC'
  accepts_nested_attributes_for :comments



  before_validation :generate_sha1, :on => :create

  validates_presence_of :sha1
  validates_uniqueness_of :sha1, :message => "File was already uploaded."


  def comment
    comments.first
  end

  def path
    stuff_file.queued_for_write[:original].try(:path) || stuff_file.path
  end

  def generate_sha1
    self.sha1 = Digest::SHA1.hexdigest(File.read(path)) if stuff_file?
  end

end

