class SquareType < ActiveRecord::Base
	has_one :squares
	#def self.table_name () "mem_square_types" end
end
