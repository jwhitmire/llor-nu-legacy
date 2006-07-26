class Dice
	def self.roll
		# picks a random number, changes the users square_id, decrements their "turns" for the day
		#numbers = [1,2,3,4,5,6].sort_by {srand}
		#number = numbers[0]		
		mt = Random::MT19937.new(Time.now.to_i % rand(1000000))
		number = mt.rand(6)+1
	end
end
