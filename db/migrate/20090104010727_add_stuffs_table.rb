class AddStuffsTable < ActiveRecord::Migration
  def self.up
    create_table(:stuffs, :force => true, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8') do |t|
      t.integer :id
      t.integer :size
      t.string :filename
      t.string :content_type
      t.string :md5
      t.timestamps
    end
  end

  def self.down
    drop_table :stuffs
  end
end

