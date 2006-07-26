class RemoveUserIdColumns < ActiveRecord::Migration
  def self.up
    remove_column :accounts, :user_id
  end
end
