require File.dirname(__FILE__) + '/../test_helper'
require 'inventory_controller'

# Re-raise errors caught by the controller.
class InventoryController; def rescue_action(e) raise e end; end

class InventoryControllerTest < Test::Unit::TestCase
  fixtures :users, :items, :user_items, :accounts
  
  def setup
    @controller = InventoryController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:user] = User.find(1)
  end

  def test_viewing_inventory
    user = User.find(1)
    user.active_user_item = 2
    get :index
    assert assigns(:user), '@user should exist for the action..duh!'
    assert assigns(:active_item)
    assert_not_nil assigns(:active_item)
    assert_not_nil assigns(:user).find_active_item, "User should have an active item"
    assert_equal [assigns(:user).find_active_item], User.find(1).user_items.select {|i| i.active? }  
    assert_tag :tag => 'img', :attributes => { :src => '/images/item_1.png' }
    assert_tag :tag => 'img', :attributes => { :src => '/images/item_1.png', :class => 'active' }
    assert_tag :tag => 'img', :attributes => { :src => '/images/item_1.png', :class => 'inactive' }
    
    assert_tag :tag => 'b', :content => 'Active'
  end
  
  def test_activating_item
    User.find(1).active_user_item = 1
    get :item_activate, :id => 1
    assert assigns(:user), '@user should exist for the action..duh!'
    assert_not_nil assigns(:user).find_active_item, 'The user should have their item activated.'
  end
  
  def test_deactivating_item
    User.find(1).active_user_item = 1
    get :item_deactivate, :id => 1
    assert assigns(:user), '@user should exist for the action..duh!'
    assert_nil assigns(:user).find_active_item, 'The user shouldn\' have an active item'
  end

end
