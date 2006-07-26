class DeedsCountCaching < ActiveRecord::Migration
  def self.up
    c = columns(:squares).collect { |c| c.name }  
    add_column(:squares, :deeds_count, :integer, :default => 0) unless c.include?'deeds_count'

    c = columns(:squares).collect { |c| c.name }  
    if c.include?'deeds_count'
      Square.find(:all).each do | square |
        if square.deed
  	  square.deeds_count=1
	  square.save!
        end
      end
    end
  rescue => err
    self.down
    raise err
  end

  def self.down
    c = columns(:squares).collect { |c| c.name }
    remove_column(:squares, :deeds_count) if c.include?'deeds_count'
  end
end
