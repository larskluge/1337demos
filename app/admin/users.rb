ActiveAdmin.register User do
  index do
    column :approved do |user|
      check_box_tag 'approved', '1', user.approved
    end
    column :name do |user|
      render_nickname_plain(user.name)
    end
    column :mail
    column :created_at
    default_actions
  end

  before_save do |user|
    user.accessible = [:approved]
    user.attributes = params[:user]
  end

end

