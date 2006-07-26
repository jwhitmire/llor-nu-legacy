class HelpController < ApplicationController
	layout  'play'
  def index
    if @session[:user]
      @user = User.find(@session[:user][:id])
    end
  end
end
