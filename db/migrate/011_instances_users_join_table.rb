class InstancesUsersJoinTable < ActiveRecord::Migration
  def self.up
    create_table :instance_users, :id => false do |table|
      table.column :user_id, :integer
      table.column :instance_id, :integer
      table.column :created_on, :datetime
      table.column :updated_on, :datetime
    end
  end
  def self.down
    drop_table :instance_users
  end
end
