require File.dirname(__FILE__) + '/../test_helper'

class DeedTest < Test::Unit::TestCase
  fixtures :deeds
  fixtures :payments
  fixtures :property_types

  def setup
    @deed = Deed.find(1)
  end

  # Replace this with your real tests.
  def test_total_revenue
    assert_equal 3200, @deed.total_revenue 
    assert_equal 105, deeds(:another_deed).total_revenue
  end

  def test_rent
    assert_equal 60, deeds(:first_deed).rent
    assert_equal 40, deeds(:another_deed).rent
    assert_equal 20, deeds(:deed3).rent
  end

  def test_cost_to_upgrade
    assert_equal 2970, deeds(:first_deed).cost_to_upgrade(3)
    assert_equal 25650, deeds(:first_deed).cost_to_upgrade(11)
    assert_equal 970, deeds(:another_deed).cost_to_upgrade(5)
    assert_equal 10120, deeds(:another_deed).cost_to_upgrade(15)
  end
 
  def test_cost_to_sell
    assert_equal 882, deeds(:another_deed).cost_to_sell(3)
    assert_equal 3582, deeds(:another_deed).cost_to_sell(0)
    assert_equal 2700, deeds(:first_deed).cost_to_sell(1)
    assert_equal 5427, deeds(:first_deed).cost_to_sell(0)
  end
 
end
