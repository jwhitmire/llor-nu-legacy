require File.dirname(__FILE__) + '/../test_helper'

class SettingTest < Test::Unit::TestCase
  fixtures :settings

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Setting, settings(:first)
  end
end
