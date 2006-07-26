require File.dirname(__FILE__) + '/../test_helper'

class UserItemTest < Test::Unit::TestCase
  fixtures :user_items

  def setup
    @user_item = UserItem.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of UserItem,  @user_item
  end
end
