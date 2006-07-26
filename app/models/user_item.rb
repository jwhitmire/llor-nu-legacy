class UserItem < ActiveRecord::Base
	belongs_to :user
	belongs_to :item
	belongs_to :instance
	
	def use
	  self.uses_left -= 1
	  self.save
	  if self.uses_left == 0
	    self.destroy
	  end
	end
	
  def self.find_active_item
    self.find(:first, :conditions => 'active = 1')
  end
  # clears all active items and sets it to the id
  def self.activate_item=(new_id)
    self.deactivate_items
    i = self.find(new_id)
    i.update_attribute(:active, 1) if i
    i
  end
  def self.deactivate_items
    items = self.find(:all, :conditions => 'active = 1')
    items.each do |item|
      item.active = 0
      item.save
    end
  end		
	def self.find_items(user)
		# pick a random item from the items first:		
		item_id = rand(2)+1
		
		# now, apply some creation rules for each item
		case
			when item_id == 1
				if rand(100)+1 > (100-user.user_instance.instance.setting.value["special_items"]["duck"]["odds"].to_i)
				  uses = 3
				  apply_mode = 1 # used on next turn
					message = 'You found a Persuasive Duck! It\'s been added to your <a href="/inventory/">inventory.</a>'					
				end
			when item_id == 2
			  if rand(100)+1 > (100-user.user_instance.instance.setting.value["special_items"]["hard_hat"]["odds"].to_i)
			    uses = 1
			    apply_mode = 2 # used on current turn
			    message = 'You found a Hard Hat of Seriousness!'
			  end
			when item_id == 3
			  if rand(100) == 50
			    uses = 1
			    apply_mode = 2 # used on current turn
			    message = 'You found some Creamy Ice Filled Wafers of Transportation!'
			  end
		end
		
		if uses
		  if user.user_instance.user_items.find(:all,:conditions => ['item_id = ?',item_id]).size > 0
  	    item = user.user_instance.user_items.find(:first,:conditions => ['item_id = ?',item_id])
  	    item.uses_left += uses
  	    item.save
  	  else	    
  	    item = self.new
  	    item.item_id = item_id
  	    item.user_instance_id = user.user_instance.id
        item.uses_left = uses
        item.apply_mode = apply_mode
        item.active = 0
        item.user_id = user.id
        item.save
       end
    end
		
		return message
	end
	def self.first_items(user,instance,settings)	  
	  #settings["special_items"]["starting_items"].each do |item|
	  # only ducks supported as a starting item right now
	    self.create(:user_id => user.id, :item_id => settings["special_items"]["starting_items"]["duck"]["id"], :uses_left => settings["special_items"]["starting_items"]["duck"]["uses_left"], :active => 1, :apply_mode => 1, :instance_id => instance.id)
    #end	  
	end
	def self.apply_duck(user)
		# find the active item, if any
		item = user.user_instance.user_items.find(:first, :conditions => 'active = 1')
		
		if item
			case
				when item.item.id == 1
					# Apply Free Rent
					# need to know - square, rent paid, if any
					if user.square.deed and user.square.deed.user.id != user.id
						# figure out rent
						rent_total = user.square.deed.property_type.rent(user.square.deed.levels)
						rent_discount = rand(user.user_instance.instance.setting.value["special_items"]["duck"]["range"])
											
						if user.square.deed.name
							message = "Welcome to #{user.square.deed.name}. You would have paid #{user.square.deed.user.name} #{rent_total} in rent had your Persuasive Duck not negotiated it to #{rent_discount.to_i}."
						else
							message = "You would have paid #{user.square.deed.user.name} #{rent_total} in rent had your Persuasive Duck not negotiated it to #{rent_discount.to_i}."
						end
						
						if item.uses_left.nil? or item.uses_left <= 1
							message += " Too bad he ran away now. So sad."
							item.destroy
						else
							item.uses_left -= 1
							item.save
							item.reload
							message += " You have #{item.uses_left} uses left."
						end							
					end
					return rent_discount || 0
			end
		end
	end
end
