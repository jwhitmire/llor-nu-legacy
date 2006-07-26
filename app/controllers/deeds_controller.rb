class DeedsController < ApplicationController
  layout 'play' 
	helper :play

  # These filter methods preload the relevant information for every action in
  # this controller, this helps us not repeat ourselves by loading the user
  # over and over
  before_filter :reload_user
  before_filter :load_building, :only => [ :upgrade, :downgrade, :sell, :rename, :show, :save_building_title ]
  
  protected
  # Refresh the user data from the database, based on the session user ID
  # This method could redirect or display an error page, rather than just
  # raise.
  def reload_user
    @user = User.find(session[:user][:id])
  end
  
  # Load the building information from the params.
  def load_building
    @deed = @user.user_instance.instance.deeds.find(params[:id])
  rescue ActiveRecord::RecordNotFound
		@custom_error = "You can't try and edit someone else's building. That'd be cheating."
		render :partial => "/play/error"
		return false
  end
  
  public

  # Show the page for buying a new building.
	def build
		pos = params[:page] || 1
		@properties = PropertyType.find(:all, :order=>"position", :conditions => ['position = ?', pos])
		if @properties.nil?
			@custom_error = "Could not find that property type."
			render :partial => "/play/error"
			return
    end
		render :partial => "build"
	end
	
	def buy
		property_type = PropertyType.find(params[:id])
		@active_item = @user.user_instance.user_items.find_active_item
		if params[:levels].to_i > PropertyType.get_max_levels(property_type.id,@user).to_i || params[:levels].to_i < 1
			params[:levels] = PropertyType.get_max_levels(property_type.id,@user).to_i
		end
		
		# determine total cost, based on the levels they picked
		total_cost = property_type.cost(params[:levels].to_i)
		# check account, and if good, make purchase (but only if the square isn't deeded)
		if @user.square.locked?(@user)
			session[:messages] = "<p>Sale failed! Someone is in the middle of building here.</p>"
		elsif @user.user_instance.account.balance >= total_cost and not @user.square.has_deed? and @user.square.square_type.id == 3
			# make purchase
			@deed = Deed.new
			@deed.property_type_id = property_type.id
			@deed.user = @user
			@deed.square = @user.square
			@deed.instance = @user.user_instance.instance
			@deed.levels = params[:levels]
				
			# convert square to player owned
			@deed.square.change_type(2)
			# we do this last so the previous save doesn't overwrite the counter cache
			@deed.square.deeds_count += 1
			@deed.save
			
			@event = event = Event.create(:user_id => @user.id, :event_type_id => 2, :user_instance_id => @user.user_instance.id)
			@payment = Payment.create(:user_id => @user.id, :amount => -total_cost, :event_id => event.id)
			session[:messages] = "<p>You just built a hotel here.</p>"
			
			Account.debit!(@user,total_cost)
			session[:balance] = @user.user_instance.account.balance
			Square.doler(@user.user_instance.instance)
		else
			# send a message back saying it couldn't be done
			session[:messages] = "<p>Couldn't buy the property due to low funds or the fact that it's already owned.</p>"
		end
		redirect_to :controller => "js", :action => "index"
	end
	
	def upgrade	  
	  session[:message] = "<p>Return to your <a href=\"buildings\">buildings</a>.<br/>"
	  session[:message] += "Return to the <a href=\"play\">game</a>.</p>"
		if !request.post? or @deed.levels == @deed.property_type.max_levels
		  #nothing to be done here, folks!
			render :partial => "/play/edit_building"
			return
		end
		
		property_type = @deed.property_type
		
		if params[:levels].to_i > PropertyType.get_max_levels(@deed.property_type_id,@user) || params[:levels].to_i < 1
			new_levels=0
		else
		  new_levels=params[:levels].to_i
		end		
		
		# cap what we can build if we're going over'
		if @deed.levels+new_levels > PropertyType.get_max_levels(@deed.property_type_id,@user)
			new_levels = PropertyType.get_max_levels(@deed.property_type_id,@user)-@deed.levels
		end

		# determine total cost, based on the levels they picked
		upgrade_price = @deed.cost_to_upgrade(@deed.levels+new_levels)

		# check funds, make sure possible to upgrade
		if @user.user_instance.account.balance < upgrade_price		
			@custom_error = "You don't have enough money to upgrade."
			render :partial => "/play/error"
			return
		end

		@deed.update_attribute(:levels, @deed.levels + new_levels)
		
		event = Event.create(:user_id => @user.id, :event_type_id => 5, :user_instance_id => @user.user_instance.id)
		Payment.create(:user_id => @user.id, :amount => - upgrade_price, :event_id => event.id)
			
		Account.debit!(@user,upgrade_price)
		@deed.reload
		session[:balance] = @user.user_instance.account.balance
		session[:message] += "<p>You upgraded your building.</p>"
		render :partial => "/play/edit_building"
  end	  
	  
  def downgrade
	  sell
	end
	
	def sell
		property_type = @deed.property_type
		if params[:levels].to_i <= 0
		  sell_levels=0
		elsif params[:levels].to_i >= @deed.levels
		  sell_levels=@deed.levels
		else
		  sell_levels=params[:levels].to_i
		end
		sell_price=@deed.cost_to_sell(@deed.levels-sell_levels)
		event = Event.create(:user_id => @user.id, :event_type_id => 4, :user_instance_id => @user.user_instance.id)
		Payment.create(:user_id => @user.id, :amount => sell_price, :event_id => event.id)
		Account.credit!(@user,sell_price)
		session[:balance] = @user.user_instance.account.balance

		if @deed.levels == sell_levels
			# we're selling the entire building
			@deed.square.change_type(3)
			@deed.destroy
#			redirect_to :controller => "js", :action => "index"
			flash[:notice]="Building and property sold."
			redirect_to :action => "list"
		else
			@deed.update_attribute (:levels, @deed.levels-sell_levels)
			@deed.reload
			render :partial => 'play/edit_building'
		end
end
	
  # List all the buildings for a player
	def list
	  if params[:order]
	    direction = params[:direction].nil? ? ' desc' : ' asc'
	    @order = case params[:order].downcase
      #when 'rent':
      #  'sum(payments.amount)'
      #when 'visits'
      #  'deeds.landed_on'
      when 'name':
        'deeds.name'
      when 'levels':
        'deeds.levels'
      when 'health':
        'deeds.health'
      else
        'deeds.id'
      end
    end
    
    page = (params[:page] ||= 1).to_i
    items_per_page = 20
    offset = (page - 1) * items_per_page
    
    @buildings = @user.user_instance.instance.deeds.find(:all,:conditions => "user_id = #{@user.id}", :order => @order ? @order + direction : "deeds.position")
    @building_pages = Paginator.new(self, @buildings.length, items_per_page, page)
    @buildings = @buildings[offset..(offset + items_per_page - 1)]
    
		#@building_pages, @buildings = paginate :deeds, 
		#    :include => [ :property_type, :square, :instance], 
		#    :conditions => ['deeds.user_id = ? AND deeds.instance_id = ?', @user.id, @user.user_instance.instance.id], 
		#    :per_page => 20,
		#    :order => @order ? @order + direction : "deeds.position"
  end
  
  def show
  end

	def edit_building_title
		render :partial => 'edit_building_title'
	end

	def save_building_title
		if @deed.update_attribute("name", params[:deed][:name])
			render :partial => 'building_title'
		else
			render :text => "Couldn't save."
		end
	end
  def minimal
		@user = User.find(session[:user][:id])
		@deed = Deed.find(params[:id])
		
		if @user.user_instance.account.balance > 50
		  @user.user_instance.account.balance -= 50
			#Account.update(@user.account.id, :balance => @user.account.balance -= 50)
			event = Event.create(:user_id => @user.id, :event_type_id => 7, :user_instance_id => @user.user_instance.id)
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
		
		redirect_to :controller => "deeds", :action => 'show', :id => params[:id]
	end
	def maximum
		@user = User.find(session[:user][:id])
		@deed = Deed.find(params[:id])
		
		total_maintenance_cost = (14 - @deed.health) * 50
		
		if @user.user_instance.account.balance > total_maintenance_cost
		  @user.user_instance.account.update_attribute(:balance, @user.user_instance.account.balance - total_maintenance_cost)
			#Account.update(@user.account.id, :balance => @user.account.balance -= total_maintenance_cost)
			event = Event.create(:user_id => @user.id, :event_type_id => 7, :user_instance_id => @user.user_instance.id)
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
		
		redirect_to :controller => "deeds", :action => 'show', :id => params[:id]
	end
end
