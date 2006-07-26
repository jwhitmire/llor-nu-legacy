require File.dirname(__FILE__) + '/../test_helper'

class PropertyTypeTest < Test::Unit::TestCase
  fixtures :property_types

  def setup
    @property_type = PropertyType.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of PropertyType,  @property_type
  end

  def test_rent
    @cheap=property_types(:cheap)
    assert_equal 10, @cheap.rent(1)
    assert_equal 150, @cheap.rent(15)
    @super=property_types(:super_insane)
    assert_equal 360, @super.rent(9)
    assert_equal 960, @super.rent(24)
  end

  def test_cost
    @cheap=property_types(:cheap)
    assert_equal 1010, @cheap.cost(1)
    assert_equal 7800, @cheap.cost(8)
    @super=property_types(:super_insane)
    assert_equal 34920, @super.cost(9)
    assert_equal 85920, @super.cost(24)
  end
  
end
