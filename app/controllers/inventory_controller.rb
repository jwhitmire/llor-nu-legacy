class InventoryController < ApplicationController
  layout 'play'  
  def index
		@user = User.find(@session[:user][:id])
	end	
end
