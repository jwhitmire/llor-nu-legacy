class MassiveBoard < ActiveRecord::Migration
  def self.up
    execute "update squares set position=position*100000"
  end

  def self.down
    raise IrreversibleMigration
  end
end
