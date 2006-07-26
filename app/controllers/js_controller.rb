class JsController < ApplicationController
	before_filter :login_required
	before_filter :reload_user
	
	protected
	def reload_user
	  # shortcut for grabbing these on every action
    @user = User.find(session[:user][:id])
  end
  
	public	
	def index
	  # check to see if the player has joined an instance first
	  if @user.user_instance == nil
	    redirect_to :controller => "instances", :action => "choose"
	    return
	  end
	  
	  session[:messages] = "<p>Waiting for you to roll the dice.</p>"
	  
	  if @user.square	
		  @squares = Square.next_batch(@user.square.position,@user.user_instance.instance,21).compact
    else
      @squares = Square.next_batch(1,@user.user_instance.instance,21).compact
    end
    
    if @user.square.square_type_id == 3
      session[:messages] += "<p>You can <a href=\"#\" onclick=\"new Ajax.Updater('x', '/build/', {asynchronous:true, evalScripts:true, onComplete:function(request){action_window_down()}, onLoading:function(request){action_window_up()}}); return false;\">buy and build</a> on this property.</p>"
    end
    if @user.square.deed and @user.square.deed.user.id == session[:user][:id]
      session[:messages] += "<p>You own this building. Clap your hands and say yeah!</p>"
    end
    
		@active_item = @user.user_instance.user_items.find_active_item
		
		@god_message = GodMessage.latest
		session[:fullscreen]=false
		session[:tile_cache]=18
		session[:balance] = @user.user_instance.account.balance
	end
	def take_turn
	  session[:messages] = ""
	  session[:roll] ||= Dice.roll
	  
	  User.transaction do
      # js client tells us about a new position, so we move them there.		
      @user.square = Square.find_by_relative_position(@user.square.position,session[:roll],@user.user_instance.instance)
    
      begin
        # save position and bypass validations
        @user.save(false)
      rescue ActiveRecord::RecordInvalid => invalid
        session[:messages] += "<p>" + invalid.record.errors.inspect + "</p>"
      end
    end
      # find an item and set the item found message
      item_message = UserItem.find_items(@user)
      if item_message != nil
        session[:messages] += "<p>" + item_message + "</p>"
      end
    
      # if a duck is being applied, figure out the discounted rent
      discounted_rent = UserItem.apply_duck(@user) || 0
      session[:messages] += "<p>" + Square.land_on_square(@user,discounted_rent) + "</p>"
			
			@squares = Square.next_batch(@user.square.position,@user.user_instance.instance,21).compact
		  @active_item = @user.user_instance.user_items.find_active_item
		  @items = @user.user_instance.user_items
  		render :action => "take_turn", :layout => false
  		session[:roll] = nil
	end	
	def render_die
		render :partial => "die"
	end
	
	def render_balance
		account = @user.user_instance.account
		session[:balance] = @balance = account.balance
		render :partial => "balance"
	end
	
	def render_active_item
		@active_item = @user.user_instance.user_items.find_active_item
		render :partial => "active_item"
	end
	def render_buildings
		
	end
	def immediate_item
	  @item = UserItem.find(params[:id])
	  
	  #@squares = Square.next_batch(@user.square.position,21).compact
		#@active_item = @user.find_active_item
		#@god_message = GodMessage.latest
		#session[:fullscreen]=false
		#session[:tile_cache]=18
	  
	  ######
	  # These rules are hard coded for now for each item. I'd love a rule's system that made this dynamic
	  ######
	  #session[:messages] += "There are issues with this feature that are currently being worked on. Hang tight.<br /> #{@item.item_id}"
	  if @item.item_id.to_i == 2 # hard hat
	      #session[:messages] += "There are issues with this feature that are currently being worked on. Hang tight.<br /> {hard_hat}"
			  # destroys a random number of floors of at the current square on buildings 1 story or greater
			  # pays the person who destroyed the floors what the owner would sell them for
			  # pays the owner 1 credit as an insult (and as an easy event to track)			   
			  if @user.square.deed and @user.square.deed.user.id != @user.id
			    if @user.square.deed.levels > 1			    
			      levels_to_destroy = (2..@user.square.deed.levels).to_a.sort_by {rand}[0] - 2
			      
			      # enforce the max range
			      if @user.user_instance.instance.setting.value["special_items"]["hard_hat"]["range"].to_i < levels_to_destroy
			        levels_to_destroy = @user.user_instance.instance.setting.value["special_items"]["hard_hat"]["range"].to_i - 2
			      end
			      
			      if levels_to_destroy == 0
			        session[:messages] += "<p>You failed at destroying any levels! You tried to be bad and you failed!</p>"
			        @item.use			        
			      else
			        session[:messages] += "<p>You scoundrel! You destroyed #{levels_to_destroy} levels!</p>"
			        @item.use
			        
			        total_loot = @user.square.deed.property_type.cost(levels_to_destroy)			        
			        # update both user accounts
				      Account.update(@user.user_instance.account.id, :balance => @user.user_instance.account.balance += total_loot)
      				Account.update(@user.square.deed.user.user_instance.account.id, :balance => @user.square.deed.user.user_instance.account.balance += 1)      				
      				pay = Event.create(:user_id => @user.id, :event_type_id => 11, :user_instance_id => @user.user_instance.id)
      				get = Event.create(:user_id => @user.square.deed.user.id, :event_type_id => 12, :user_instance_id => @user.square.deed.user.user_instance.id)      				
      				Payment.create(:user_id => @user.square.deed.user.id, :amount => 1, :event_id => pay.id, :deed_id => @user.square.deed.id)				
      				Payment.create(:user_id => @user.id, :amount => total_loot, :event_id => get.id, :deed_id => @user.square.deed.id)
			        
			        @user.square.deed.levels -= levels_to_destroy
			        @user.square.deed.save
		        end
			    else
			      session[:messages] += "<p>You can only use the Helmet of Seriousness on buildings over 1 level.</p>"
			    end
			  else
			    session[:messages] += "<p>You can\'t use that item on this square.</p>"
			  end			 
			  render :partial => "inventory_bar"		
		else
		  render :partial => "inventory_bar"
		end
	  
	  
	end
	def item_activate
	  session[:messages] = session[:messages] || ""
    @user.user_instance.user_items.activate_item = params[:id]
    session[:messages] += "<p>Your Persuasive Duck is now active.</p>"
		render :partial => "inventory_bar"
	end

	def item_deactivate
	  session[:messages] = session[:messages] || ""
		@user.user_instance.user_items.deactivate_items
		session[:messages] += "<p>Your Persuasive Duck has been deactived.</p>"
		render :partial => "active_item"
	end
  def bar    
  end
  def update_messages
    render :partial => "messages"
  end
  def update_active_item
    @active_item = @user.user_instance.user_items.find_active_item
    
    render :partial => "active_item"
  end
  def update_inventory_bar
    render :partial => "inventory_bar"
  end
  def debug_tool
    render :inline => "<%= debug params %>"
  end
end
