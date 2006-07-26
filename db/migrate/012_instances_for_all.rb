class InstancesForAll < ActiveRecord::Migration
  def self.up
    add_column :accounts, :instance_id, :integer
    add_column :events, :instance_id, :integer
    add_column :messages, :instance_id, :integer
    add_column :scores, :instance_id, :integer
    add_column :squares, :instance_id, :integer
    add_column :user_items, :instance_id, :integer
  end
  def self.down
    remove_column :accounts, :instance_id
    remove_column :events, :instance_id
    remove_column :messages, :instance_id
    remove_column :scores, :instance_id
    remove_column :squares, :instance_id
    remove_column :user_items, :instance_id
  end
end
