class Item < ActiveRecord::Base
	has_many :user_items
	#def self.table_name () "mem_items" end
end
