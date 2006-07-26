require File.dirname(__FILE__) + '/../test_helper'
require 'property_types_controller'

# Re-raise errors caught by the controller.
class PropertyTypesController; def rescue_action(e) raise e end; end

class PropertyTypesControllerTest < Test::Unit::TestCase
  fixtures :property_types

  def setup
    @controller = PropertyTypesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_index
    get :index
    assert_response 302 #:success
    #assert_template 'list'
  end

  def test_list
    get :list

    assert_response 302 #:success
    #assert_template 'list'

    #assert_not_nil assigns(:property_types)
  end

  def test_show
    get :show, :id => 1

    assert_response 302 #:success
    #assert_template 'show'

    #assert_not_nil assigns(:property_type)
    #assert assigns(:property_type).valid?
  end

  def test_new
    get :new

    assert_response 302 #:success
    #assert_template 'new'

    #assert_not_nil assigns(:property_type)
  end

  def test_create
    num_property_types = PropertyType.count

    post :create, :property_type => {}

    assert_response 302 #:redirect
    #assert_redirected_to :action => 'list'

    assert_equal num_property_types, PropertyType.count, "Nothing should be changed"
  end

  def test_edit
    get :edit, :id => 1

    assert_response 302 #:success
    #assert_template 'edit'

    #assert_not_nil assigns(:property_type)
    #assert assigns(:property_type).valid?
  end

  def test_update
    post :update, :id => 1
    assert_response 302
    #assert_response :redirect
    #assert_redirected_to :action => 'show', :id => 1
  end

  def test_destroy
    assert_not_nil PropertyType.find(1)

    post :destroy, :id => 1
    assert_response 302
    assert_not_nil PropertyType.find(1)
    
    #assert_response :redirect
    #assert_redirected_to :action => 'list'

    #assert_raise(ActiveRecord::RecordNotFound) {
    #  PropertyType.find(1)
    #}
  end

end
