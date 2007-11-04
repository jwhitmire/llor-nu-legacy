class AddLockedAtToSquares < ActiveRecord::Migration
  def self.up
    add_column :squares, :locked_at, :datetime
  end

  def self.down
    remove_column :squares, :locked_at
  end
end
