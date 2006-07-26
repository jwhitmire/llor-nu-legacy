class RestController < ApplicationController	
	def roll
		@headers["Content-Type"] = "text/xml; charset=utf-8"
		@user = User.find(@session[:user][:id])
		square_ids = next_squares(17).collect {|s| s.id}		
		@other_users = User.find(:all, :conditions => ['square_id in (?) and id != ?',square_ids, @session[:user][:id]], :limit => 10)		
	end
	def status
		render :action => "roll"
	end
	def random_number
		@headers["Content-Type"] = "text/plain;"
		@session[:roll] = Dice.roll		
		render :text => @session[:roll]
	end
	def messenger
		render :text => "Hello"
	end
	def current_building
		
	end
end