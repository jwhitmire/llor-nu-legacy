class InstancesController < ApplicationController
  before_filter :login_required
	layout  'play'
	def index
	  redirect_to :action => "choose"
	end
  def choose
    @user = User.find(session[:user][:id])
    @instances = Instance.find(:all)
  end
  def join    
    user = User.find(session[:user][:id])    
    UserInstance.join_or_create(user.id,params[:id].to_i)
    user.reload
    
    redirect_to :controller => 'js', :action => 'index'
  end
  def new
    @user = User.find(@session[:user][:id])
  end
  def create
    @user = User.find(session[:user][:id])
    if @user.role == 'admin' # kevin is sneaky
      null=nil
      parsed_settings = eval(params[:packet].gsub(/(["'])\s*:\s*(['"0-9tfn\[{])/){"#{$1}=>#{$2}"})
    
      instance = Instance.create(:user_id => session[:user][:id], :name => params[:name], :description => params[:description])    
      Setting.create(:value => parsed_settings, :instance_id => instance.id)
     	Square.first_squares(instance.setting.value,instance)
 	  end
   	# at this point there are no users associated with the instance - that happens when a user joins the instance   
  end
end
