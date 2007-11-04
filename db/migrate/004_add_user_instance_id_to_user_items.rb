class AddUserInstanceIdToUserItems < ActiveRecord::Migration
  def self.up
    add_column :user_items, :user_instance_id, :integer
  end

  def self.down
    remove_column :user_items, :user_instance_id
  end
end
