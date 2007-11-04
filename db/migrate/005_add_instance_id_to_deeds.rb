class AddInstanceIdToDeeds < ActiveRecord::Migration
  def self.up
    add_column :deeds, :instance_id, :integer
  end

  def self.down
    remove_column :deeds, :instance_id
  end
end
