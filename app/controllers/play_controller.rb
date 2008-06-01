class PlayController < ApplicationController	
	before_filter :login_required, :except => [:home,:about]
	
	def home		
	end	

	def payments
		@user = User.find(session[:user][:id])
		if @user		
			@activity = Payment.recent_activity(@user)
		else
			@custom_error = "I can't figure out who you are because your session is funky. Maybe delete any cookies from llor.nu and give it another go?"
			render :partial => "error"
		end
	end
	def profile
		@player = User.find(params[:id])		
		render :partial => "profile"
	end
	
	def scores
	  @user = User.find(session[:user][:id])
		@scores = Account.find_by_sql("
		  select accounts.balance, 
		    deeds.user_id,
		    count(deeds.id) as deeds,
		    property_types.id,
		    levels,
		    sum((levels * (1000*property_types.position)) + ((levels * level_modifier)* (0.5 * (levels+1)))) as total_deed_value,
		    sum((levels * (1000*property_types.position)) + ((levels * level_modifier)* (0.5 * (levels+1)))) + accounts.balance as total
		  from deeds 
		    inner join property_types on deeds.property_type_id = property_types.id 
		    inner join accounts on accounts.user_id = deeds.user_id
		    inner join user_instances on user_instances.id = accounts.user_instance_id
		    inner join instances on instances.id = user_instances.instance_id
        where instances.id = #{@user.user_instance.instance_id}
		  group by accounts.user_id		  
		  order by total desc")
		  
		counter = 0
		@scores.each do |score|
			if score.user_id == session[:user][:id]
				@rank = counter
			end
			counter += 1
		end
		
		@user = User.find(session[:user][:id])
	end

	def bank		
		@user = User.find(session[:user][:id])
	end

	def minimal
		@user = User.find(session[:user][:id])
		@deed = Deed.find(params[:id])
		
		if @user.account.balance > 50
		  @user.account.balance -= 50
			#Account.update(@user.account.id, :balance => @user.account.balance -= 50)
			event = Event.create(:user_id => @user.id, :event_type_id => 7)
			Payment.create(:user_id => @user.id, :amount => -50, :event_id => event.id)
		
			@deed.health += 1
			@deed.save
			@deed.reload
		
			payments = Payment.find(:all, :conditions => ['deed_id = ? AND user_id = ?',@deed.id, session[:user][:id]])
			@revenue = 0
			payments.each do |payment|
				@revenue += payment.amount
			end
		else
			
		end
		
		redirect_to :action => 'building', :id => params[:id]
	end
	def maximum
		@user = User.find(session[:user][:id])
		@deed = Deed.find(params[:id])
		
		total_maintenance_cost = (14 - @deed.health) * 50
		
		if @user.account.balance > total_maintenance_cost
		  @user.account.update_attribute(:balance, balance - total_maintenance_cost)
			#Account.update(@user.account.id, :balance => @user.account.balance -= total_maintenance_cost)
			event = Event.create(:user_id => @user.id, :event_type_id => 7)
			Payment.create(:user_id => @user.id, :amount => -total_maintenance_cost, :event_id => event.id)
		
			@deed.health = 14
			@deed.save
			@deed.reload
		
			payments = Payment.find(:all, :conditions => ['deed_id = ? AND user_id = ?',@deed.id, session[:user][:id]])
			@revenue = 0
			payments.each do |payment|
				@revenue += payment.amount
			end		
		else
			
		end
		
		redirect_to :action => 'building', :id => params[:id]
	end
	
	def messages
		@user = User.find(session[:user][:id])
		if params[:id]
			# get messages for a single square
			#@messages = Message.find(:all, :conditions => ['square_id = ?',params[:id]], :order => "created_on DESC")
			@message_pages, @messages = paginate :messages, :conditions => ['square_id = ?',params[:id]], :order_by => "created_on DESC",  :per_page => 10
		else
			@message_pages, @messages = paginate :messages, :order_by => "created_on DESC", :per_page => 10
			#@messages = Message.find(:all, :order => "created_on DESC")
		end
	  session[:last_viewed_message] = [ session[:last_viewed_message] || 1, @messages.first.id ].max unless @messages.length == 0
	end
	
	def drop_message
		@message = Message.new
		@message.user_id = session[:user][:id]
		@message.message = params[:message]
		if params[:id]
			@message.square_id = params[:id]
		end		
		@message.save
		
		if params[:id]
			@message_pages, @messages = paginate :messages, :conditions => ['square_id = ?',params[:id]], :order_by => "created_on DESC",  :per_page => 10
		else
			@message_pages, @messages = paginate :messages, :order_by => "created_on DESC", :per_page => 10
		end
		
		render :partial => "live_messages"
	end
	def about	 
	end
end
