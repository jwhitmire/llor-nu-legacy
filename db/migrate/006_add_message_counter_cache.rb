class AddMessageCounterCache < ActiveRecord::Migration
  def self.up
    add_column :squares, :messages_count, :integer
    Square.find(:all).each do |square|
      messages=square.messages.count
      if messages>0
	Square.update_all(["messages_count = ?",messages], ["id = ?", square.id])
      end
    end
  rescue
    down
    raise
  end

  def self.down
    remove_column :squares, :messages_count
  end
end
