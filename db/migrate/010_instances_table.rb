class InstancesTable < ActiveRecord::Migration
  def self.up
    create_table :instances do |table|
      table.column :name, :string, :limit => 100
      table.column :user_id, :integer
      table.column :created_on, :datetime
      table.column :updated_on, :datetime
    end
  end
  def self.down
    drop_table :instances
  end
end
