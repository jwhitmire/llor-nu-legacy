require File.dirname(__FILE__) + '/../test_helper'

class EventTypeTest < Test::Unit::TestCase
  fixtures :event_types

  def setup
    @mysquare = EventType.find(:first)
  end

  def test_csv_fixtures_loaded
    setup
    assert_not_nil @mysquare
    assert_equal 10, EventType.count
  end
end
