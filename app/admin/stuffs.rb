ActiveAdmin.register Stuff do
  index do
    column :file do |stuff|
      link_to stuff.stuff_file_file_name, stuff.stuff_file.url
    end
    column :size do |stuff|
      number_to_human_size stuff.stuff_file_file_size.to_i
    end
    column :name do |stuff|
      render_nickname_plain(stuff.comment.user.name)
    end
    column :message do |stuff|
      stuff.comment.message
    end
    column :created_at
    default_actions
  end
end

