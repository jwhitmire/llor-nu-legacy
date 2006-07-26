class AddSquareId < ActiveRecord::Migration
  def self.up   
    add_column :user_instances, :square_id, :integer
    add_column :user_instances, :active, :integer
  end
  def self.down
    remove_column :user_instances, :square_id
    remove_column :user_instances, :active
  end
end
