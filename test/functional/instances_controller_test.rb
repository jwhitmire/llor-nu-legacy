require File.dirname(__FILE__) + '/../test_helper'
require 'instances_controller'

# Re-raise errors caught by the controller.
class InstancesController; def rescue_action(e) raise e end; end

class InstancesControllerTest < Test::Unit::TestCase
  def setup
    @controller = InstancesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
