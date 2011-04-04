class Comment < ActiveRecord::Base
  attr_accessible :message, :commentable_type, :user_attributes

  belongs_to :user
  accepts_nested_attributes_for :user
	belongs_to :commentable, :polymorphic => :true

  delegate :name, :mail_pass, :to => :user

	validates_presence_of :message, :user, :commentable_type
  validates_length_of :message, :maximum => 255

  after_validation :replace_user_with_existing

  scope :approved, joins(:user).where(:users => {:approved => true})
  scope :welcome, where(:commentable_type => 'Welcome')
  scope :demo, where(:commentable_type => 'Demo')


	def demo
    @demo ||= if self.commentable_type == 'Demo'
                Demo.find(self.commentable_id)
              end
	end


  protected

  def replace_user_with_existing
    if user.try(:new_record?)
      existing = User.find_by_name_and_passphrase(user.name, user.passphrase)
      self.user = existing if existing
    end
  end

end

