require File.dirname(__FILE__) + '/../test_helper'

class StatisticTest < Test::Unit::TestCase
  fixtures :statistics

  def setup
    @statistic = Statistic.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Statistic,  @statistic
  end
end
