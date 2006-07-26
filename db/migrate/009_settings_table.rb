class SettingsTable < ActiveRecord::Migration
  def self.up
    create_table :settings do |table|
      table.column :variable, :string, :limit => 100
      table.column :value, :text
      table.column :instance_id, :integer
      table.column :created_on, :datetime
      table.column :updated_on, :datetime
    end
  end
  def self.down
    drop_table :settings
  end
end
