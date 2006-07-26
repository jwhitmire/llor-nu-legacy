module AdminHelper
	def csv_builder(squares)
		string = ""
			squares.each do |square| 
			if square.deed
				levels = square.deed.levels
				case
					when square.deed.property_type.id == 1 then
						string += "2,1,#{levels}\n" 
					when square.deed.property_type.id == 2 then
						string += "2,2,#{levels}\n" 		
					when square.deed.property_type.id == 3 then
			 			string += "2,3,#{levels}\n" 
		 			when square.deed.property_type.id == 4 then
			 			string += "2,4,#{levels}\n" 
	 			end 
 			else
 				case
	 				when square.square_type.id == 5 then
						string += "5\n" 
			 		when square.square_type.id == 3 then
						string += "3\n" 
				 	else 
						string += "1\n" 
				end
			end 
		end
		return string
	end
end
