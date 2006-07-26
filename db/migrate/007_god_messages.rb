class GodMessages < ActiveRecord::Migration
  def self.up
    create_table :god_messages do |table|
      table.column :message, :string, :limit => 300
      table.column :instance_id, :integer
    end
  end

  def self.down
    drop_table :god_messages
  end
end
