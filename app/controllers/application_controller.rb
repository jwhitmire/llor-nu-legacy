# The filters added to this controller will be run for all controllers in the application.
# Likewise will all the methods added be available for all controllers.
require_dependency "login_system"

class ApplicationController < ActionController::Base  
    include LoginSystem
    
  	helper :user
  	#model  :user # do not remove - Dreamer3

	#before_filter :game_down
	
	def game_down
	  if request.remote_addr == '127.0.0.1' or request.remote_addr == '24.21.178.229'
	  
	  else
	    render :partial => "play/down"  
    end		
	end
	
  
	helper_method :rent_calc, :cost_calc, :upgrade_calc, :downgrade_calc
	
	# this is a stupid stop gap fix for the localization crap
	def l(string)
		return string
	end	
	
	def rent_calc(property_type,level)
		property_type.rent(level)
	end
	
	def cost_calc(property_type,level)
		property_type.cost(level)
	end
	
	protected  
	
	#def surprise_money
	#	# randomly, users can stumble across surprise money
	#	if rand(100)+1 > $SETTINGS["surprise_money"]["odds"]
	#		@user = User.find(@session[:user][:id])
	#	
	#		Account.update_all("balance = #{@user.account.balance += $SESSION[:surprise_money][:payout]}","id = #{@user.account.id} and instance_id = #{session[:instance_id]}")
	#		event = Event.create(:user_id => @user.id, :event_type_id => 9, :instance_id => session[:instance_id])
	#		Payment.create(:user_id => @user.id, :amount => $SESSION[:surprise_money][:payout], :event_id => event.id, :instance_id => session[:instance_id])
	#		flash.now['surprise'] = "You found #{$SESSION[:surprise_money][:payout]}! Lucky!"
	#	end
	#end
end
