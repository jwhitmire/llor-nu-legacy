class AddInstanceId < ActiveRecord::Migration
  def self.up
    add_column :settings, :instance_id, :integer
  end

  def self.down
    remove_column :settings, :instance_id
  end
end
