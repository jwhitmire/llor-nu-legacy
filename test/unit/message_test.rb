require File.dirname(__FILE__) + '/../test_helper'

class MessageTest < Test::Unit::TestCase
  fixtures :messages

  def setup
    @message = Message.find(1)
  end

  def test_messages_since
    assert_equal 1, Message.count_since(1)
    assert_equal 0, Message.count_since(2)
  end
end
