class AdminController < ApplicationController
  def daily
    if session[:user][:role] == 'admin'
      if $SETTINGS["building_decay"] != 0
        # decay buildings
        Deed.decay        
      end
    
      # add funds to all users
      if $SETTINGS["daily_allowance"] != 0
        @users = User.find(:all)

        @users.each do |user|
          event = Event.create(:user_id => user.id, :event_type_id => 6)
          Payment.create(:user_id => user.id, :amount => $SETTINGS["daily_allowance"], :event_id => event.id)
          user.account.balance += $SETTINGS["daily_allowance"]
          user.save
        end
      end
    end
  end  
  
   def email_news
    if session[:user][:role] == 'admin'
      if params[:test]
        @users = User.find(1)
      else
   	    @users = User.find(:all)
 	    end
   	
     	@users.each do |user|
     		begin
     		UserNotify.deliver_email_news(user)
     		rescue
     		end
     	end
     	
     	render :text => "done"
    else
      render :text => "not authed"
 	  end
   	
   end
   def reset_game(instance_id)
    if session[:user][:role] == 'admin'
   	if params[:p] and params[:p] == 'corn'
   	# set player balances to starting point
   	
   	## THIS TRUNCATING BUSINESS IS ALL BROKEN DUE TO INSTANCES ###
   	   				
   		# remove all found items
   		#ActiveRecord::Base.connection.execute('TRUNCATE TABLE user_items')
   		## remove all square locks
   		##ActiveRecord::Base.connection.execute('TRUNCATE TABLE square_locks')
   		## remove all deeds
   		#ActiveRecord::Base.connection.execute('TRUNCATE TABLE deeds')
   		## remove all payments
   		#ActiveRecord::Base.connection.execute('TRUNCATE TABLE payments')
   		#ActiveRecord::Base.connection.execute('TRUNCATE TABLE events')
   		## remove all squares
   		#ActiveRecord::Base.connection.execute('TRUNCATE TABLE squares')
   		#ActiveRecord::Base.connection.execute('TRUNCATE TABLE messages')
   	  
   		#Account.starting_balance
   	  #UserItem.first_items
   		#Square.first_squares   		
   	  #User.first_positions
   	else
   		render :text => "you totally didn't do anything"
   	end
 	  end
   end  
end
