require File.dirname(__FILE__) + '/../test_helper'

class InstanceTest < Test::Unit::TestCase
  fixtures :instances

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Instance, instances(:first)
  end
end
