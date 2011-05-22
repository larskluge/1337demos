ActiveAdmin.register Announcement do
  index do
    column :message do |announcement|
      render :inline => announcement.message rescue nil
    end
    column :created_at
    default_actions
  end
end

