require File.dirname(__FILE__) + '/../test_helper'
require 'play_controller'

# Re-raise errors caught by the controller.
class PlayController; def rescue_action(e) raise e end; end

class PlayControllerTest < Test::Unit::TestCase
  fixtures :users, :deeds, :squares, :payments, 
            :property_types, :accounts, :user_items, :items,
            :messages
  
  def setup
    @controller = PlayController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:user] = User.find(1)
  end

  def test_everything_works
    actions = %w{ home payments bank messages scores notice_balance notice_payment 
      roll rolling last_roll status_area roll_nav } # inventory, buildings moved away
    actions.each do |page|
      assert_nothing_raised("should render #{page}") { get(page.to_sym) }
    end
    # actions requiring an id
    actions = %w{ profile }
    actions.each do |page|
      assert_nothing_raised("Should render #{page}") { get page.to_sym, :id => 1 }
    end
  end
  
  def test_message_posting
    old_session_count = @request.session[:last_viewed_message]
    message_count = Message.count
    assert_nothing_raised { 
      get :messages
      post :drop_message, :message => "This is my leet test."
    }
    assert_equal message_count + 1, Message.count
    assert_equal 1, @request.session[:last_viewed_message]
    #Message.find(:all)[-1].id
    post :drop_message, :message => "This is my leet test.", :square_id => 1
    assert_equal message_count + 2, Message.count
    get :messages
    assert_equal Message.find(:all)[-1].id, @request.session[:last_viewed_message]
  end
  
  def test_scores
    assert_nothing_raised { get :scores }
  end
  
  
end
