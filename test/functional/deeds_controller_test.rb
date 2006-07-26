require File.dirname(__FILE__) + '/../test_helper'
require 'deeds_controller'

# Re-raise errors caught by the controller.
class DeedsController; def rescue_action(e) raise e end; end

class DeedsControllerTest < Test::Unit::TestCase
  fixtures :deeds, :users, :squares, :accounts, :property_types

  def setup
    @controller = DeedsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:user] = User.find(:first)
  end

  def test_before_filter
    @request.session[:user][:id] = 1234567
    assert_raise(ActiveRecord::RecordNotFound) { get :buy }

    @request.session[:user] = User.find(:first)
    get :upgrade, :id => 12345
    assert_template '_error'
  end

  def test_controller_works
    [:build, :buy, :upgrade, :list, :sell, :rename, :show ].each do |page|
      assert_nothing_raised("should render #{page}") { get page, :id => 2 }
    end   
    [:sell, :upgrade].each do |page|
      get page, :id => 1
      assert assigns(:user), "should assign @user in the view for #{page}"
      assert assigns(:deed), "should assign @deed in the view for #{page}"
      assert_equal 1, assigns(:deed).id, 'should assign deed #1 in the view'
    end 
  end
  
  def test_buy
    d = Deed.count
    @user=@request.session[:user]
    @user.square = Square.find(:first, :conditions=>['deeds_count=0'])
    assert_not_nil @user.square
    @user.save
    get :buy, :id => 4, :levels => 2
    assert assigns(:user)
    assert assigns(:deed)
    assert_equal d+1, Deed.count, "Should create a deed here"
    
  end

  # def test_sell
  # end
  
  def test_upgrade
    old_cash = User.find(1).account.balance
    
    assert_equal 2, deeds(:first_deed).levels
    get :upgrade, :id => deeds(:first_deed)
    assert_equal 2, deeds(:first_deed).reload.levels, "Shouldn't add a level in GET"
    # ahah..
    post :upgrade, :id => deeds(:first_deed).id, :levels => 1
    assert_equal 3, Deed.find(deeds(:first_deed).id).levels, "Should add a level to the building for POST"
    assert_not_equal old_cash, User.find(1).account.balance, "should be a different balance now"
    assert old_cash > User.find(1).account.balance, "should remove $ from user"
  end

  def test_list
    get :list
    assert assigns(:buildings)
    assert_equal 2, assigns(:buildings).size
    assert assigns(:building_pages)
    assert assigns(:building_pages).is_a?ActionController::Pagination::Paginator
    
    #todo: test ordering.
    %w' visits rent health name messages '.each do |ordering|
      assert_nothing_raised { get :list, :order => ordering }
      assert assigns(:order)
    end
  end
  
  def test_build
    get :build
    assert_template '_build'
    assert assigns(:properties)
    
    get :build, :page => 4
    
  end
  
  def test_show
    get :show, :id => deeds(:first_deed).id
    assert assigns(:user)
    assert assigns(:deed), "@deed should be set in the response"
    assert_equal 3200, assigns(:deed).total_revenue
    assert_template 'show'
    
    get :show, :id => 5
    assert_template '_error'
  end

  def test_cheat_upgrade
    deed_id=User.find(1).deeds.first.id
    get :show, :id => deed_id
    assert assigns(:deed), "@deed should be set in the response"
    orig_levels=assigns(:deed).levels
    get :save_building_title, :id => deed_id, :deed => { :levels => 20 }
    assert assigns(:deed)
    assert_equal orig_levels, assigns(:deed).levels

    get :save_building_title, :id => deed_id, :deed => { :name => "Elvis Land" }
    assert_equal "Elvis Land", assigns(:deed).name
  end
  
  def test_sell
    deed=User.find(1).deeds.first
    orig_levels=deed.levels
    get :sell, :id => deed.id, :levels =>1
    assert assigns(:deed)
    assert orig_levels-1, assigns(:deed).levels
  end

  def test_sell_completely
    deed=User.find(1).deeds.last
    square=deed.square
    assert_equal 2, square.square_type_id
    total_deeds=User.find(1).deeds.count
    get :sell, :id => deed.id, :levels =>2
    assert assigns(:deed)
    assert total_deeds-1, User.find(1).deeds.count
    square.reload
    assert_equal 3, square.square_type_id
    assert_raise (ActiveRecord::RecordNotFound, "This deed should be missing.") { Deed.find(deed.id) }
  end
 
  def test_upgrade_building
    
  end
 
end
