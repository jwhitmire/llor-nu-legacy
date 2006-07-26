require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  fixtures :users, :squares, :accounts, :user_items
    
  def test_find_active_item
    assert_equal user_items(:ducky_instance), User.find(1).find_active_item 
  end
   
  def test_use_turn
    @bob = User.find(:first)
    @bob.turns=20
    @bob.save
    @bob.use_turn!
    @bob.use_turn!
    @bob.use_turn!
    assert_equal 17, @bob.turns
    @bob.use_turn!(6)
    assert_equal 11, @bob.turns
    @bob.use_turn!(25)
    assert_equal 0, @bob.turns
  end
   
  def test_auth
    assert_equal users(:bob), User.authenticate("bob", "atest"), "* Should log in as bob"
    assert_nil User.authenticate("nonbob", "aftest"), "Should not log in as nonbob"
  end


  def test_disallowed_passwords
    
    u = User.new    
    u.login = "nonbob"

    u.password = u.password_confirmation = "tiny"
    assert !u.save     
    assert u.errors.invalid?('password')

    u.password = u.password_confirmation = "hugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehuge"
    assert !u.save     
    assert u.errors.invalid?('password')
        
    u.password = u.password_confirmation = ""
    assert !u.save    
    assert u.errors.invalid?('password')
        
    u.password = u.password_confirmation = "bobs_secure_password"
    u.name = 'yabbdo'
    u.firstname = 'bobbboboob'
    u.lastname = 'yeya'
    u.email = 'corny@fofo.com'
    
    assert u.save     
    assert u.errors.empty?
        
  end
  
  def test_bad_logins

    u = User.new  
    u.password = u.password_confirmation = "bobs_secure_password"

    u.login = "x"
    assert !u.save     
    assert u.errors.invalid?('login')
    
    u.login = "hugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhug"
    assert !u.save     
    assert u.errors.invalid?('login')

    u.login = ""
    assert !u.save
    assert u.errors.invalid?('login')

    u.login = "okbob"
    u.name = "yabba"
    u.firstname = 'bobbboboob'
    u.lastname = 'yeya'
    u.email = 'corny@fofo.com'
    
    assert u.save  
    assert u.errors.empty?      
  end


  def test_collision
    u = User.new
    u.login      = "existingbob"
    u.password = u.password_confirmation = "bobs_secure_password"
    assert !u.save
  end
  
  def test_sha1
    u = User.new
    u.name = 'ydodod'
    u.login      = "nonexistingbob"
    u.password = u.password_confirmation = "bobs_secure_password"
    u.firstname = 'bobbboboob'
    u.lastname = 'yeya'
    u.email = 'corny@fofo.com'
    
    assert u.save
    u.reload
        
    assert_equal '98740ff87bade6d895010bceebbd9f718e7856bb', u.password    
  end


  def test_create
    u = User.new
    u.login      = "nonexistingbob"
    u.name = "yabba"
    u.password = u.password_confirmation = "bobs_secure_password"
    u.firstname = "newbob"
    u.lastname = "last"
    u.email = "corny@yoiks.com"
    
    assert u.save    
  end

  def test_find_active_item
    assert true # stub
  end
  
  def test_deactivate_items
    @bob = User.find(1)
    @bob.user_items.each { |item| item.update_attribute(:active, 0) }
    @bob.user_items.first.active = true
    @bob.user_items.first.save!
    assert @bob.save
    assert_not_nil @bob.reload.find_active_item, 'User should start this test with an active item'
    @bob.deactivate_items
    assert_equal nil, @bob.find_active_item, "Should have cleared active items."
  end

  def test_active_user_items
    @bob = User.find(1)
    @bob.user_items.each { |item| item.update_attribute(:active, 0) }
    assert_nil @bob.find_active_item
    assert_equal 2, @bob.user_items.size
    
    old_item = @bob.find_active_item
    @bob.active_user_item = 1
    @bob.reload
    assert_not_equal old_item, @bob.find_active_item
  end
 
  def test_initial_setup
    u = User.new
    u.login      = "nonexistingbob"
    u.name = "yabba"
    u.password = u.password_confirmation = "bobs_secure_password"
    u.firstname = "newbob"
    u.lastname = "last"
    u.email = "corny@yoiks.com"
    u.square_id = 47
    u.save
    
    a = Account.new
    a.user_id = u.id
    a.balance = 5000
    a.save
    
    assert 5000,a.balance
    assert u.id,a.user_id
    
  end
 
end
