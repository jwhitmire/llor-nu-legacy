class AddUserInstanceIdToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :user_instance_id, :integer
  end

  def self.down
    remove_column :events, :user_instance_id
  end
end
