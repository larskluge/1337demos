ActiveAdmin.register Comment, :as => 'Komment' do
  scope :shouts, default: true do |comments| comments.where(commentable_type: 'Welcome') end
  scope :demos do |comments| comments.where(commentable_type: 'Demo') end
  scope :stuffs do |comments| comments.where(commentable_type: 'Stuff') end

  index do
    column :approved do |shout|
      check_box_tag 'approved', '1', shout.user.approved
    end
    column :name do |shout|
      render_nickname_plain(shout.user.name)
    end
    column :message
    column :on do |comment|
      "#{render_linked_players comment.demo.players} on #{render_linked_map comment.demo.map}".html_safe if comment.demo
    end
    column :created_at
    default_actions
  end
end

