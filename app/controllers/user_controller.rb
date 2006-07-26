class UserController < ApplicationController
  model   :user
  layout  'play'
  
  before_filter :login_required, :except => [:play,:login,:signup,:forgot_password,:password_reset]
  
	def play
		redirect_to :controller => 'js', :action => 'index'
	end
	
  def login
    case @request.method
      when :post
      if @session[:user] = User.authenticate(params[:user][:login], params[:user][:password])                
        # do all the login related stuff        
        flash['notice']  = "Login successful"
        redirect_to :controller => 'instances', :action => "choose"
      else
        flash.now['notice']  = "Login unsuccessful"
        @login = params[:user_login]
      end
    end
  end  
  
  def signup
    @user = User.new(params[:user])
        
    if @request.post? and @user.save      
      @session[:user] = User.authenticate(@user.login, params[:user][:password])      
      #@user.first_account
      #@user.first_items
            
      flash['notice']  = "Signup successful"
      redirect_to :controller => 'instances', :action => "choose"
    end      
  end
  
  def logout
    @session[:user] = nil
    @session[:instance_id] = nil
    flash['notice']  = "You've been logged out. See you next time!"
    redirect_to :action => "login"
  end
  
  def forgot_password
    if @request.post? and params[:user][:email].length > 0 and params[:user][:login].length > 0
      @user = User.find(:first, :conditions => ['email = ? AND login = ?',params[:user][:email],params[:user][:login]])
      if @user.nil?
        flash.now['error']  = "Email or login don't match a valid player."
      else
        @user.password = params[:user][:password]
        if @user.save
          redirect_to :action => "login"
          flash['notice']  = "Your password has been reset to #{params[:user][:password]}"
        end
      end
    elsif @request.post?
      flash.now['error']  = "Email or login don't match a valid player."    
    end
  end
  def edit
    @user = User.find(session[:user][:id])
  end
  def save_settings
    @user = User.find(session[:user][:id])
    @user.name = params[:user][:name]
    @user.lastname = params[:user][:lastname]
    @user.firstname = params[:user][:firstname]
    @user.email = params[:user][:email]    
    if @user.save
      flash['notice'] = "Settings saved"
    end
    
    render :partial => 'settings_saved'
  end
end
