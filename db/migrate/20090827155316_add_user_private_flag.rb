class AddUserPrivateFlag < ActiveRecord::Migration
  def self.up
    add_column :users, :private_flag, :boolean
  end

  def self.down
    remove_column :users, :private_flag, :boolean
  end
end
