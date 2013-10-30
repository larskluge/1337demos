ActiveAdmin.register User do

  controller do

    def update
      resource.approved = params[:user].delete(:approved) if params[:user][:approved]
      super
    end

  end

  index do
    column :approved do |user|
      approve_check_box_tag_for user
    end
    column :name do |user|
      render_nickname_plain(user.name)
    end
    column :mail
    column :created_at
    default_actions
  end

end

