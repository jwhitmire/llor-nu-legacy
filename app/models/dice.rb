class Dice
	def self.roll
		# picks a random number, changes the users square_id, decrements their "turns" for the day
		numbers = [1,2,3,4,5,6].sort_by {srand}
		number = numbers[0]
	end
end
