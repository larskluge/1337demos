class HashDemofilesWithSha1 < ActiveRecord::Migration
  def self.up
    add_column :demofiles, :sha1, :string, :limit => 40

    # Demofile.find_each do |demofile|
    #   demofile.update_attributes!(:sha1 => Digest::SHA1::hexdigest(File.read(demofile.full_filename)))
    # end

    add_index :demofiles, :sha1

    remove_column :demofiles, :md5
  end

  def self.down
    add_column :demofiles, :md5, :string

    remove_index :demofiles, :column => :sha1
    remove_column :demofiles, :sha1
  end
end

