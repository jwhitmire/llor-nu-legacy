require File.dirname(__FILE__) + '/../test_helper'

class SquareTest < Test::Unit::TestCase
  fixtures :squares, :deeds, :payments, :users, :square_types

  def setup
    @square = Square.find(:first)
  end
  
  def test_create
    # make a few new squares and give them a position.
    empty_square = Square.new(:square_type_id => 1)
    @squares = []
    6.times do |i|
  	  empty_square.position = i
  	  @squares += [empty_square.clone]
    end
    assert_equal 6, @squares.length
  end

  def test_change_types
    @square.change_type(1)
    assert_equal 1, @square.square_type.id
    @square.change_type(2)
    assert_equal 2, @square.square_type.id
    @square.change_type(3)
    assert_equal 3, @square.square_type.id
  end

  def test_has_deed
    # find a vacant square
    @square = Square.find(:first, :conditions => 'deeds_count = 0')
    assert_not_nil @square
    assert_equal false, @square.has_deed?
    deed = @square.create_deed
    assert deed.errors.empty?, "Deed should be created with no validation problems"
    @square.reload
    assert_equal true, @square.has_deed?, "Should create a deed for the square"
  end

  def test_next_batch
    assert_equal [3,4,5,6,7], Square.next_batch(5, 5).collect { |n| n.position }
    assert_equal [11,12,13,1], Square.next_batch(13, 4).collect { |n| n.position }
    assert_equal [12,13,1], Square.next_batch(1, 3).collect { |n| n.position }
    assert_equal [10,11,12,13,1,2], Square.next_batch(12, 6).collect { |n| n.position }
  end

  def test_position_based_locking
    @bob = users(:bob)
    @josh = users(:josh)
    @boardwalk = squares(:boardwalk)
    @parkplace = squares(:parkplace)
    # neither should be locked at first
    assert !@boardwalk.locked?
    assert !@parkplace.locked?
    # move josh to parkplace and lock
    @josh.square=@parkplace
    @josh.save
    @parkplace.lock!(@josh)
    # make sure it's locked for bob'
    assert @parkplace.locked?(@bob)
    @josh.square=@boardwalk
    # move josh away, make sure it's unlocked for bob
    @josh.save
    assert !@parkplace.locked?(@bob)
  end

  def test_time_based_locking
    @bob=users(:bob)
    @josh=users(:josh)
    @parkplace=squares(:parkplace)
    @josh.square=@parkplace
    @josh.save
    @parkplace.lock!(@josh)
    # make sure it's locked for bob'
    assert @parkplace.locked?(@bob)
    # josh has been gone for 20 minutes
    @josh.square.locked_at=Time.now-20.minutes
    @josh.square.save
    # make sure bob can get a lock
    assert !@parkplace.locked?(@bob)
  end

  def test_cant_lock_ourselves_out
    @bob=users(:bob)
    @josh=users(:josh)
    @parkplace=squares(:parkplace)
    @josh.square=@parkplace
    @josh.save
    @parkplace.lock!(@josh)
    assert @parkplace.locked?(@bob)
    assert !@parkplace.locked?(@josh)
  end

  def test_two_user_lock_same_square
    @bob=users(:bob)
    @josh=users(:josh)
    @parkplace=squares(:parkplace)
    # bob on parkplace first
    @bob.square=@parkplace
    @bob.save
    @parkplace.lock!(@bob)
    # josh ther esecond
    @josh.square=@parkplace
    @josh.save
    # should be locked to josh
    assert @parkplace.locked?(@josh)
  end
  
  def test_empty_square
    assert_equal 1, Square.empty.square_type_id
    assert Square.empty.empty?
  end
  
  def test_next_batch
    @bob = users(:bob)
    assert_not_nil @bob.square
    @squares = Square.next_batch(@bob.square.position, 0)
    assert_not_nil @squares
    assert_equal 2, @squares.size
    @squares = Square.next_batch(@bob.square.position, 21)
    assert_not_nil @squares
    assert_equal 21, @squares.size
    # get an absurb # of squares to ensure we wrap arround several times
    @squares = Square.next_batch(@bob.square.position, 121)
    assert_not_nil @squares
    assert_equal 121, @squares.size
  end

  def test_find_by_relative_position_not_return_nil
    squares=Square.count
    (1..squares).each do |i|
      6.times do |roll|
	square=Square.find_by_relative_position(i,roll+1)
	assert_not_nil square
      end
    end
    position=1
    200.times do 
      roll=rand(6)+1
      square=Square.find_by_relative_position(position,roll)
      assert_not_nil square
    end
  end

  def test_find_next_position
    assert_equal 8, Square.find_by_relative_position(3,5).position
    assert_equal 13, Square.find_by_relative_position(12,1).position
    assert_equal 2, Square.find_by_relative_position(12,3).position
    assert_equal 12, Square.find_by_relative_position(12,13).position
    assert_equal 1, Square.find_by_relative_position(13,14).position
    assert_equal 12, Square.find_by_relative_position(12,13).position
    assert_equal 12, Square.find_by_relative_position(12,26).position
  end
  
end
