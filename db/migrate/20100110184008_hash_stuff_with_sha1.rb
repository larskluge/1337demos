class HashStuffWithSha1 < ActiveRecord::Migration
  def self.up
    add_column :stuffs, :sha1, :string, :limit => 40

    Stuff.find_each do |stuff|
      stuff.update_attributes!(:sha1 => Digest::SHA1::hexdigest(File.read(stuff.full_filename)))
    end

    add_index :stuffs, :sha1

    remove_column :stuffs, :md5
  end

  def self.down
    add_column :stuffs, :md5, :string

    remove_index :stuffs, :column => :sha1
    remove_column :stuffs, :sha1
  end
end

