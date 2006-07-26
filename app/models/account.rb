class Account < ActiveRecord::Base
	belongs_to :user
	belongs_to :user_instance
		
	def real_estate_worth
		total_deed_value = 0
		if self.user.deeds != nil
			self.user.deeds.each do |deed|
				total_deed_value += (deed.property_type.base_price + (deed.property_type.level_cost * deed.levels))		
			end
		end
		return total_deed_value
	end

	def self.debit!(user,cash)
		self.update_all("balance = balance - #{cash}","user_instance_id = #{user.user_instance.id} and user_id = #{user.id}")
	end
	
	def self.credit!(user,cash)
	  self.update_all("balance = balance + #{cash}","user_instance_id = #{user.user_instance.id} and user_id = #{user.id}")
	end
  def self.sum(user_instance_id)
    self.find_by_sql("SELECT SUM(balance) as total_cash FROM accounts WHERE user_instance_id = #{user_instance_id}")[0].total_cash.to_i
  end
  def starting_balance
    # this may be obsolete - accounts should only be created when a user joins an instance
    self.update_all(['balance = ?',$SETTINGS["starting_balance"]])
  end
  #def self.check_account(user,instance,starting_balance)
  #  if self.find(:all, :conditions => ['instance_id = ? and user_id = ?',instance.id,user.id]).size == 0      
  #    self.create(:user_id => user.id, :instance_id => instance.id, :balance => starting_balance)
  #  end
  #end
  def self.pay_rent(user,discounted=0)
		if user.square.deed
			if user.square.deed.user.id != user.id
				rent = user.square.deed.property_type.rent(user.square.deed.levels)
				Deed.update_all "landed_on = landed_on + 1", "id = #{user.square.deed.id}"
				if discounted != 0
					rent_with_discount = discounted
				else
					rent_with_discount = rent
				end
				
				# time to pay some rent!
				
				# look up both user accounts
				Account.update_all("balance = balance - #{rent_with_discount}","id = #{user.user_instance.account.id} and user_instance_id = #{user.user_instance.id}")
				Account.update_all("balance = balance + #{rent}", "id = #{user.square.deed.user.user_instance.account.id} and user_instance_id = #{user.user_instance.id}")
				
				# make some events for the rent payment
				pay = Event.create(:user_id => user.id, :event_type_id => 1, :user_instance_id => user.user_instance.id)
				get = Event.create(:user_id => user.square.deed.user.id, :event_type_id => 8, :user_instance_id => user.user_instance.id)
				
				# pay the rent
				Payment.create(:user_id => user.square.deed.user.id, :amount => -rent, :event_id => pay.id, :deed_id => user.square.deed.id)				
				Payment.create(:user_id => user.id, :amount => rent_with_discount, :event_id => get.id, :deed_id => user.square.deed.id)
				
				if user.user_instance.account.balance <= 0
					user.user_instance.account.balance = 0
				  user.save
				end
				
				message = "You paid #{user.square.deed.user.name} #{rent} in rent."
								
				if user.square.deed.name
					message = "Welcome to \"#{user.square.deed.name}\". " + message
				end			
			end
		end
		return message
	end
	def self.quicky_money(user)
		winnings = rand(user.user_instance.instance.setting.value["quickie_payout"])
			
		self.update_all("balance = #{user.user_instance.account.balance += winnings}","id = #{user.user_instance.account.id} and user_instance_id = #{user.user_instance.id}")
		event = Event.create(:user_id => user.id, :event_type_id => 10, :user_instance_id => user.user_instance.id)
		Payment.create(:user_id => user.id, :amount => winnings, :event_id => event.id)
		message = "You found a lottery ticket outside the Quicky and won #{winnings}"	 
	end
end