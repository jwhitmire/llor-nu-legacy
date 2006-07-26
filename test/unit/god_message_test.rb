require File.dirname(__FILE__) + '/../test_helper'

class GodMessageTest < Test::Unit::TestCase
  fixtures :god_messages

  def setup
    @god_message = GodMessage.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of GodMessage,  @god_message
  end
end
