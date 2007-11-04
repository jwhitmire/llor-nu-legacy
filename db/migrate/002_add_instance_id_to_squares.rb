class AddInstanceIdToSquares < ActiveRecord::Migration
  def self.up
    add_column :squares, :instance_id, :integer
  end

  def self.down
    remove_column :squares, :instance_id
  end
end
