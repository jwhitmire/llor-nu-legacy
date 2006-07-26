class NewLockingSystem < ActiveRecord::Migration
  def self.up
    add_column :squares, :locked_by_id, :integer, :default => nil
    add_column :squares, :locked_at, :datetime, :default => nil
    SquareLock.find(:all).each do | lock |
      lock.square.locked_by_id=lock.user_id
      lock.square.locked_at=lock.created_on
      lock.square.save!
    end
  end

  def self.down
    remove_column :squares, :locked_by
    remove_column :squares, :locked_at
  end
end
