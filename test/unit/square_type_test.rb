require File.dirname(__FILE__) + '/../test_helper'

class SquareTypeTest < Test::Unit::TestCase
  fixtures :square_types

  def setup
    @square_type = SquareType.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of SquareType,  @square_type
  end
end
