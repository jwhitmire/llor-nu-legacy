class DropSquareLockTable < ActiveRecord::Migration
  def self.up
    drop_table :square_locks
  end

  def self.down
    raise IrreversibleMigration
  end
end
