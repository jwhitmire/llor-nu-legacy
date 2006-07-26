class Square < ActiveRecord::Base
#	acts_as_list
  belongs_to :instance
	has_many :users
	belongs_to :square_type
	has_one :deed
	has_one :square_lock
	has_many :messages
	belongs_to :locked_by, :class_name => 'User', :foreign_key => 'locked_by_id'
		
	# has_deed? depreciated
	alias deeded? has_deed?
	def deeded?
		self.deeds_count>0
	end

	def locked?(user=nil)
		return false if self.locked_by.nil?
		return false if user and self.locked_by_id==user.id
		return false if Time.now-self.locked_at > 10.minutes
		# if the user why created this lock is now on a different square
		#return false if user and self.locked_by.square != self
		true
	end

	def lock!(user)
		self.locked_by=user
		self.locked_at=Time.now
		self.class.update_all(["locked_by_id = ?, locked_at = ?",user.id, Time.now],["id = ?", self.id])
		# can corrupt positions by saving old data over them
#		self.save!
	end

	def change_type(type_id)
		self.class.update_all(["square_type_id = ?,deeds_count = deeds_count + 1", type_id],["id = ?", self.id])
		self.square_type=SquareType.find(type_id)
	end

	def empty?
		self.square_type_id==1
	end

	def self.empty
		Square.new( :square_type_id => 1 )
	end

	# get next x squares
	def self.next_batch(position,instance,nextn = 0,options={})
		options.reverse_merge!( :extra_two_empty => true )
		squares = []
		squares = [Square.empty, Square.empty] if options[:extra_two_empty]
		squares += Square.find(:all, :conditions => ["position >= ? AND instance_id = ?", position,instance.id], :order => "position", :limit => nextn)
		if squares.size < nextn
			while squares.size < nextn do
				squares+=Square.find(:all, :conditions => ["instance_id = ?",instance.id], :order => "position", :limit => nextn-squares.size)	
			end
		end
		squares
	end
	
	# get this square's percentage position
	def percentage_position
	  if self.position and self.instance_id
	    return (Square.count("instance_id = #{self.instance_id} and position < #{self.position}").to_f/Square.count("instance_id = #{self.instance_id}").to_f) * 100
    else
      return 0
    end
	end
	# find by relative position
	def self.find_by_relative_position(position,offset,instance)	  
		squares=Square.next_batch(position,instance,offset+1, :extra_two_empty => false)
		squares.last
	end

	def before_save
		if self.position.nil?
			begin
			  mt = Random::MT19937.new(Time.now.to_i % rand(1000000))
			  self.position = mt.rand(2000000000)+1
			end until Square.find_by_position(self.position).nil?
		end
	end

	# create squares based on global allowances
	def self.doler(instance)
		built = Square.built(instance.id)
		buyable = Square.buyable(instance.id)
		quickies = Square.quickies(instance.id)
		empties = Square.empties(instance.id)
		banks = Square.banks(instance.id)
		total_squares = Square.count("instance_id = #{instance.id}")
		settings = instance.setting.value
		
		Square.transaction do
		  if (settings["square_types"]["buyable"]/100) < (built.to_f / total_squares.to_f)
		    (((built.to_f / total_squares.to_f) - (settings["square_types"]["buyable"]/100)) * 100).ceil.times do
					square = Square.create( :square_type_id => 3, :instance_id => instance.id)
				end
			end
			
			if (settings["square_types"]["quickies"]/100) < (quickies.to_f / total_squares.to_f)
		    (((quickies.to_f / total_squares.to_f) - (settings["square_types"]["quickies"]/100)) * 100).ceil.times do			
					square = Square.create( :square_type_id => 5, :instance_id => instance.id)
				end
			end
			
			if (settings["square_types"]["empty"]/100) < (empties.to_f / total_squares.to_f)
		    (((empties.to_f / total_squares.to_f) - (settings["square_types"]["empty"]/100)) * 100).ceil.times do
					square = Square.create( :square_type_id => 1, :instance_id => instance.id)
				end
			end
			
			if (settings["square_types"]["banks"]/100) < (banks.to_f / total_squares.to_f)
		    (((banks.to_f / total_squares.to_f) - (settings["square_types"]["banks"]/100)) * 100).ceil.times do
					square = Square.create( :square_type_id => 6, :instance_id => instance.id)
				end
			end
		
		end # Square.transaction
	end
  def self.first_squares(settings,instance)
    settings["square_types"]["buyable"].to_i.times do
      square = self.new
      square.square_type_id = 3
      square.instance_id = instance.id
      square.save
    end

    settings["square_types"]["empty"].to_i.times do
      square = self.new
      square.square_type_id = 1
      square.instance_id = instance.id
      square.save
    end

    settings["square_types"]["quickies"].to_i.times do
      square = self.new
      square.square_type_id = 5
      square.instance_id = instance.id
      square.save
    end

    settings["square_types"]["banks"].to_i.times do
      square = self.new
      square.square_type_id = 6
      square.instance_id = instance.id
      square.save
    end   	
  end
	
	def self.buyable(instance_id)
	 self.count("square_type_id = 3 and instance_id = #{instance_id}")
	end
	def self.built(instance_id)
	 self.count("square_type_id = 2 and instance_id = #{instance_id}")
	end
	def self.quickies(instance_id)
	 self.count("square_type_id = 5 and instance_id = #{instance_id}")
	end
	def self.empties(instance_id)
	 self.count("square_type_id = 1 and instance_id = #{instance_id}")
	end
	def self.banks(instance_id)
	 self.count("square_type_id = 6 and instance_id = #{instance_id}")
	end
	def self.land_on_square(user,discounted_rent=0)
	  case user.square.square_type_id
    when 1
      message = 'You\'ve landed on an empty square.'
    when 2
      if user.square.deed.user == user
        message = 'You own this building. Clap your hands and say yeah!'
      else
        Account.pay_rent(user,discounted_rent)
      end
    when 3
      if user.square.locked?(user)
        message = "Someone is currently buying this property."
      else
        user.square.lock!(user)
        message = "You can <a href=\"#\" onclick=\"new Ajax.Updater('x', '/build/', {asynchronous:true, evalScripts:true, onComplete:function(request){action_window_down()}, onLoading:function(request){action_window_up()}}); return false;\">buy and build</a> on this property."
      end
    when 5
      if user.user_instance.instance.setting.value["quickie_payout"].to_i > 0
        Account.quicky_money(user)
      end
    when 6
      message = 'You\'ve arrived at the <a href="/bank/">bank</a>. Nothing to see here right now.'
	  end
	end
end
