class AddYoutubeToDemos < ActiveRecord::Migration
  def change
    remove_column :demos, :vimeo_id
    add_column :demos, :youtube_id, :string
  end
end

