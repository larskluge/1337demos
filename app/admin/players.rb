ActiveAdmin.register Player do
  index do
    column :nickname do |player|
      render_linked_player player
    end
    column :created_at

    default_actions
  end
end

