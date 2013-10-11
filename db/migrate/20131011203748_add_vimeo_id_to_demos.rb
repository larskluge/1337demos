class AddVimeoIdToDemos < ActiveRecord::Migration
  def change
    add_column :demos, :vimeo_id, :string
  end
end

