class ApproveCurrentUsers < ActiveRecord::Migration
  def self.up
    User.update_all(:approved => true)
  end

  def self.down
    User.update_all(:approved => false)
  end
end

