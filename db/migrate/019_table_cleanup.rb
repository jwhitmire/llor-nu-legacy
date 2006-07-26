class TableCleanup < ActiveRecord::Migration
  def self.up
    drop_table :instances_users
    drop_table :waiters
    drop_table :scores
  end
end
