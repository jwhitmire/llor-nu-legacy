class UserItemApplyMode < ActiveRecord::Migration
  def self.up
    add_column :user_items, :apply_mode, :integer    	  
  end
  def self.down
    remove_column :user_items, :apply_mode
  end
end
