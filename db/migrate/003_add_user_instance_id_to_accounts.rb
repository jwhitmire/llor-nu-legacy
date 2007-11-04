class AddUserInstanceIdToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :user_instance_id, :integer
  end

  def self.down
    remove_column :accounts, :user_instance_id
  end
end
