require File.dirname(__FILE__) + '/../test_helper'
require 'js_controller'

# Re-raise errors caught by the controller.
class JsController; def rescue_action(e) raise e end; end

class JsControllerTest < Test::Unit::TestCase
  def setup
    @controller = JsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:user] = User.find(1)
  end

  # Replace this with your real tests.
  def test_all_pages_render
    @request.session[:roll] = 2
    [ :index, :fullscreen, :get_square, :take_turn, :new_squares, 
      :render_scene, :render_balance, :render_active_item ].each do |page|
      assert_nothing_raised ("* #{page} should render without error.") { get page }
      assert assigns(:user)
      assert_equal 1, assigns(:user).id
    end
  end
  
  def test_index
    get :index
    assert assigns(:squares)
    assert assigns(:active_item)
    assert_equal false, @response.session[:fullscreen]
  end
      
  def test_fullscreen
    get :fullscreen
    assert_equal true, @response.session[:fullscreen]
  end
  
  def test_get_square
  end
  
  def test_take_turn
  end
  
  def test_new_squares
    @request.session[:roll] = 4
    assert_nothing_raised("Should just work") { get :new_squares }
    @request.session[:roll] = nil
    assert_nothing_raised("Should handle a null roll") { get :new_squares }
  end
  
  def test_render_scene
    # so our cache is set
    get :index
    get :render_scene
    assert assigns(:squares)
    assert assigns(:active_item)
  end
  
  def test_render_balance
  end
  
  def test_render_active_item
  end
  
end
