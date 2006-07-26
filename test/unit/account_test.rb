require File.dirname(__FILE__) + '/../test_helper'

class AccountTest < Test::Unit::TestCase
  fixtures :accounts

  def setup
    @account = Account.find(1)
  end

  # Replace this with your real tests.
  def test_debit
    @account=accounts(:joe)
    orig_balance=@account.balance
    @account.debit! 5000
    assert_equal orig_balance-5000 , @account.balance
  end

  def test_credit
    @account=accounts(:joe)
    orig_balance=@account.balance
    @account.credit! 50000
    assert_equal orig_balance+50000 , @account.balance
  end
  
end
