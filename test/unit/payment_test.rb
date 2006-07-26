require File.dirname(__FILE__) + '/../test_helper'

class PaymentTest < Test::Unit::TestCase
  fixtures :payments, :users

  def setup
    @payment = Payment.find(1)
  end

  def test_it_just_works
    assert_nothing_raised { Payment.recent_activity(User.find(:first)) }
  end
  
end
