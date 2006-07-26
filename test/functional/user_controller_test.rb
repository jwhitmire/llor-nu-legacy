require File.dirname(__FILE__) + '/../test_helper'
require_dependency 'user_controller'

# Raise errors beyond the default web-based presentation
class UserController; def rescue_action(e) raise e end; end

class UserControllerTest < Test::Unit::TestCase
  
  fixtures :users, :accounts, :payments, :squares
  
  def setup
    @controller = UserController.new
    @request, @response = ActionController::TestRequest.new, ActionController::TestResponse.new
    @request.host = "localhost"
    users(:bob).update_expiry(0)
  end
  
  def test_auth_bob
    @request.session['return-to'] = "/bogus/location"

    post :login, "user" => { "login" => "bob", "password" => "atest" }
    assert_session_has :user
    assert_equal users(:bob), @response.session[:user]    
    assert_redirect_url "http://#{@request.host}/bogus/location"
  end
  
  def do_test_signup(bad_password, bad_email)
    ActionMailer::Base.deliveries = []

    @request.session['return-to'] = "/bogus/location"

    if not bad_password and not bad_email
      post :sneaky, "user" => { "firstname" => "joseph", "lastname" => "mcTest", "name" => "jojo", "login" => "newbob", "password" => "newpassword", "password_confirmation" => "newpassword", "email" => "newbob@test.com" }
      assert_nil session[:user]
      assert_response :redirect
      assert_equal 'http://localhost/login', redirect_to_url    
      assert_equal 1, ActionMailer::Base.deliveries.size
      mail = ActionMailer::Base.deliveries[0]
      assert_equal "newbob@test.com", mail.to_addrs[0].to_s
      assert_match /login:\s+\w+\n/, mail.encoded
      assert_match /password:\s+\w+\n/, mail.encoded
      mail.encoded =~ /key=(.*?)"/
      key = $1

      user = User.find_by_email("newbob@test.com")
      assert_not_nil user
      assert_equal false, user.verified?

      # First past the expiration.
      Time.advance_by_days = 1
      get :welcome, "user"=> { "id" => "#{user.id}" }, "key" => "#{key}"
      Time.advance_by_days = 0
      user = User.find_by_email("newbob@test.com")
      assert_equal false, user.verified?

      # Then a bogus key.
      get :welcome, "user"=> { "id" => "#{user.id}" }, "key" => "boguskey"
      user = User.find_by_email("newbob@test.com")
      assert_equal false, user.verified?

      # Now the real one.
      get :welcome, "user"=> { "id" => "#{user.id}" }, "key" => "#{key}"
      user = User.find_by_email("newbob@test.com")
      assert_equal true, user.verified?

      post :login, "user" => { "login" => "newbob", "password" => "newpassword" }
      assert_session_has :user
      get :logout
    elsif bad_password
      post :sneaky, "user" => {  "firstname" => "joseph", "lastname" => "mcTest", "name" => "jojo", "login" => "newbob", "password" => "bad", "password_confirmation" => "bad", "email" => "newbob@test.com" }
      assert_session_has_no :user
      assert_invalid_column_on_record "user", "password"
      assert_success
      assert_equal 0, ActionMailer::Base.deliveries.size
    elsif bad_email
      ActionMailer::Base.inject_one_error = true
      post :signup, "sneaky" => "yes", "user" => {  "firstname" => "joseph", "lastname" => "mcTest", "name" => "jojo", "login" => "newbob", "password" => "newpassword", "password_confirmation" => "newpassword", "email" => "newbob@test.com" }
      assert_session_has_no "user"
      assert_equal 0, ActionMailer::Base.deliveries.size
    else
      # Invalid test case
      assert false
    end
  end
  
  def test_edit
    post :logout
    post :login, "user" => { "login" => "bob", "password" => "atest" }
    assert_session_has :user

    post :edit, "user" => { "firstname" => "Bob", "form" => "edit" }
    assert_equal @response.session[:user].firstname, "Bob"

    post :edit, "user" => { "firstname" => "", "form" => "edit" }
    assert_equal @response.session[:user].firstname, ""

    get :logout
  end

  def test_delete
    ActionMailer::Base.deliveries = []

    # Immediate delete
    post :login, "user" => { "login" => "deletebob1", "password" => "alongtest" }
    assert_session_has :user

    UserSystem::CONFIG[:delayed_delete] = false
    post :edit, "user" => { "form" => "delete" }
    assert_equal 1, ActionMailer::Base.deliveries.size

    assert_session_has_no :user
    post :login, "user" => { "login" => "deletebob1", "password" => "alongtest" }
    assert_session_has_no :user

    # Now try delayed delete
    ActionMailer::Base.deliveries = []

    post :login, "user" => { "login" => "deletebob2", "password" => "alongtest" }
    assert_session_has :user

    UserSystem::CONFIG[:delayed_delete] = true
    post :edit, "user" => { "form" => "delete" }
    assert_equal 1, ActionMailer::Base.deliveries.size
    mail = ActionMailer::Base.deliveries[0]
    mail.encoded =~ /user\[id\]=(.*?)&key=(.*?)"/
    id = $1
    key = $2
    post :restore_deleted, "user" => { "id" => "#{id}" }, "key" => "badkey"
    assert_session_has_no :user

    # Advance the time past the delete date
    Time.advance_by_days = UserSystem::CONFIG[:delayed_delete_days]
    post :restore_deleted, "user" => { "id" => "#{id}" }, "key" => "#{key}"
    assert_session_has_no :user
    Time.advance_by_days = 0

    post :restore_deleted, "user" => { "id" => "#{id}" }, "key" => "#{key}"
    assert_session_has :user
    get :logout
  end

  def test_signup
    do_test_signup(true, false)
    do_test_signup(false, true)
    do_test_signup(false, false)
  end

  def do_change_password(bad_password, bad_email)
    ActionMailer::Base.deliveries = []

    post :login, "user" => { "login" => "josh", "password" => "atest" }
    assert_session_has :user, "We should be able to initially log-in for the purposes of this test"

    if not bad_password and not bad_email
      post :change_password, "user" => { "password" => "changed_password", "password_confirmation" => "changed_password" }
      assert_equal 1, ActionMailer::Base.deliveries.size
      mail = ActionMailer::Base.deliveries[0]
      assert_equal "josh@topsecret.gov", mail.to_addrs[0].to_s
      assert_match /login:\s+\w+\n/, mail.encoded
      assert_match /password:\s+\w+\n/, mail.encoded
    elsif bad_password
      post :change_password, "user" => { "password" => "bad", "password_confirmation" => "bad" }
      assert_invalid_column_on_record "user", "password"
      assert_success
      assert_equal 0, ActionMailer::Base.deliveries.size
    elsif bad_email
      ActionMailer::Base.inject_one_error = true
      post :change_password, "user" => { "password" => "changed_password", "password_confirmation" => "changed_password" }
      assert_equal 0, ActionMailer::Base.deliveries.size
    else
      # Invalid test case
      assert false
    end

    get :logout
    assert_session_has_no :user

# removed while we talk about the user controller backend
#    if not bad_password and not bad_email
#      post :login, "user" => { "login" => "josh", "password" => "changed_password" }
#      assert_session_has :user, "Should be able to log-in the user"
#      post :change_password, "user" => { "password" => "atest", "password_confirmation" => "atest" }
#      get :logout
#    end

#    post :login, "user" => { "login" => "josh", "password" => "atest" }
#    assert_session_has :user

    get :logout
  end

  def test_change_password
    do_change_password(false, false)
    do_change_password(true, false)
    do_change_password(false, true)
  end

  def do_forgot_password(bad_address, bad_email, logged_in)
    ActionMailer::Base.deliveries = []

    if logged_in
      post :login, "user" => { "login" => "bob", "password" => "atest" }
      assert_session_has :user, "Should be able to log in the user initially"
    end

    @request.session['return-to'] = "/bogus/location"
    if not bad_address and not bad_email
      post :forgot_password, "user" => { "email" => "bob@test.com" }
      password = "anewpassword"
      if logged_in
        assert_equal 0, ActionMailer::Base.deliveries.size
        assert_redirect_url(@controller.url_for(:action => "change_password"))
        post :change_password, "user" => { "password" => "#{password}", "password_confirmation" => "#{password}" }
      else
        assert_equal 1, ActionMailer::Base.deliveries.size
        mail = ActionMailer::Base.deliveries[0]
        assert_equal "bob@test.com", mail.to_addrs[0].to_s
        mail.encoded =~ /user\[id\]=(.*?)&key=(.*?)"/
        id = $1
        key = $2
        post :change_password, "user" => { "password" => "#{password}", "password_confirmation" => "#{password}", "id" => "#{id}" }, "key" => "#{key}"
        assert_equal "poo", @response.flash['notice'], 'this is a fake test.'
        assert_session_has :user
        get :logout
      end
    elsif bad_address
      post :forgot_password, "user" => { "email" => "bademail@test.com" }
      assert_equal 0, ActionMailer::Base.deliveries.size
    elsif bad_email
      ActionMailer::Base.inject_one_error = true
      post :forgot_password, "user" => { "email" => "bob@test.com" }
      assert_equal 0, ActionMailer::Base.deliveries.size
    else
      # Invalid test case
      assert false
    end

    if not bad_address and not bad_email
      if logged_in
        get :logout
      else
        assert_redirect_url(@controller.url_for(:action => "login"))
      end
      post :login, "user" => { "login" => "bob", "password" => "#{password}" }
    else
      # Okay, make sure the database did not get changed
      if logged_in
        get :logout
      end
      post :login, "user" => { "login" => "bob", "password" => "atest" }
    end

    assert_session_has :user

    # Put the old settings back
    if not bad_address and not bad_email
      post :change_password, "user" => { "password" => "atest", "password_confirmation" => "atest" }
    end
    
    get :logout
  end

  def test_forgot_password
    do_forgot_password(false, false, false)
    do_forgot_password(false, false, true)
    do_forgot_password(true, false, false)
    do_forgot_password(false, true, false)
  end

  def test_bad_signup
    @request.session['return-to'] = "/bogus/location"

    post :signup, "user" => { "login" => "newbob", "password" => "newpassword", "password_confirmation" => "wrong" }
    assert_invalid_column_on_record "user", "password"
    assert_success
    
    post :signup, "user" => { "login" => "yo", "password" => "newpassword", "password_confirmation" => "newpassword" }
    assert_invalid_column_on_record "user", "login"
    assert_success

    post :signup, "user" => { "login" => "yo", "password" => "newpassword", "password_confirmation" => "wrong" }
    assert_invalid_column_on_record "user", ["login", "password"]
    assert_success
  end

  def test_invalid_login
    post :login, "user" => { "login" => "bob", "password" => "not_correct" }
    assert_session_has_no :user
    assert assigns(:login)
  end
  
  def test_login_logoff
    post :login, "user" => { "login" => "bob", "password" => "atest" }
    assert_session_has :user
    get :logout
    assert_session_has_no :user
  end
  
end
