class AddUserInstanceColumn < ActiveRecord::Migration
  def self.up
    remove_column :accounts, :instance_id
    remove_column :user_items, :instance_id
    add_column :accounts, :user_instance_id, :integer
    add_column :user_items, :user_instance_id, :integer
    add_column :events, :user_instance_id, :integer
    add_column :deeds, :instance_id, :integer # needed so that when a player views their own buildings they don't get buildings on all instances
  end
  def self.down
    remove_column :accounts, :user_instance_id
    remove_column :user_items, :user_instance_id
    remove_column :events, :user_instance_id
  end
end
