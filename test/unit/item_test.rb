require File.dirname(__FILE__) + '/../test_helper'

class ItemTest < Test::Unit::TestCase
  fixtures :items

  def setup
    @duck = items(:duck)
  end

  def test_duck
    assert_not_nil items(:duck)
  end

end
