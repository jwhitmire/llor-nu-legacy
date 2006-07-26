class DeedActsAsList < ActiveRecord::Migration
  def self.up
    add_column :deeds, :position, :integer
    User.find(:all).each do |user|
      user.deeds.each_with_index do | deed, index|
	deed.position=index+1
	deed.save
      end
    end
  end

  def self.down
    remove_column :deeds, :position
  end
end
