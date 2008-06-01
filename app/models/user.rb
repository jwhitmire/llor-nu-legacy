class User < ActiveRecord::Base    
  belongs_to :square
  belongs_to :instance
  has_one :user_instance, :conditions => "active = 1"
  
  # not yet sure if conditions are required yet...
  #has_one  :account
  #has_many :deeds
  #has_many :payments
  #has_many :events
  #has_many :user_items
  #has_one  :score
  #has_many :messages
    
  validates_presence_of :name, :firstname, :lastname, :login, :email
  validates_uniqueness_of :login, :email
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/
  validates_length_of :email, :within => 1..40
  validates_length_of :name, :minimum => 3
  validates_length_of :login, :within => 3..40
  
  validates_presence_of :password, :on => :create
  validates_confirmation_of :password, :on => :create
  validates_length_of :password, :within => 5..40, :on => :create
  
	
  @last_viewed_message = 0
	attr_protected :role 
  attr_accessor :last_viewed_message,:password
  
  def self.currently_playing
    User.count(["updated_at > ?", Time.now - 5.minutes ])
  end
  
  def self.authenticate(login, pass)
    u = find(:first, :conditions => ["login = ?", login])
    return nil if u.nil?
    find(:first,:conditions => ["login = ? AND salted_password = ?", login, salted_password(u.salt, sha1(pass))])
  end  
    
  def self.first_position(user_id,instance_id)
    highest = Square.find_by_sql("SELECT max(position) as highest FROM squares WHERE instance_id=#{instance_id}")[0].highest.to_i
    instance = Instance.find(instance_id)
    square_id = Square.find_by_relative_position(rand(highest),1,instance).id
    self.update_all("square_id = #{square_id}","id = #{user_id} and instance_id = #{instance_id}")
    return square_id
  end
  
  def self.first_positions
    self.find(:all).each do |user|
      user.square_id = rand(Square.count)+1
   		user.save
   	end
  end
  
  #def first_account
  #  Account.create(:user_id => self.id,:balance => STARTING_BALANCE)
  #end
  
  #def first_items
  #  UserItem.create(:user_id => self.id,
	#    :item_id =>   STARTING_ITEM_ID, 
	#    :uses_left => STARTING_ITEM_USES, 
	#    :active =>    STARTING_ITEM_ACTIVE,
	#    :apply_mode => 1)
  #end
  
  def join_instance(id)
    update_attribute(:instance_id,id)
    # make sure we get an account    
    self.account.check_account
    # make sure the user gets their first items
    self.UserItem.first_items(user,instance,settings)
    # place the user in a random location
    square_id = rand(Square.count)+1
 		save
  end

  # verify a user and make them active in the game.
  #def update_expiry(id)
  #  write_attribute('token_expiry', [self.token_expiry, Time.at(Time.now.to_i + 600 * 1000)].min)
  #  write_attribute('authenticated_by_token', true)
  #  write_attribute("verified", true)
	#			
	#  # give them all the good things here
	#  write_attribute('square_id', Square.find(:first, :order => "id DESC"))
	#  Account.create(:user_id => id, 
	#    :balance => STARTING_BALANCE)
	#  UserItem.create(:user_id => id, 
	#    :item_id =>   STARTING_ITEM_ID, 
	#    :uses_left => STARTING_ITEM_USES, 
	#    :active =>    STARTING_ITEM_ACTIVE)
  #  update_without_callbacks
  #end

  def use_turn!(turns=1)
    User.decrement_counter("turns",self.id)
    self.turns-=turns
    self.turns=0 if self.turns<0
  end 

  protected

  # Apply SHA1 encryption to the supplied password. 
  # We will additionally surround the password with a salt 
  # for additional security. 
  def self.sha1(str)
    Digest::SHA1.hexdigest("change-me--#{str}--")[0..39]
  end
    
  before_create :crypt_password
  
  # Before saving the record to database we will crypt the password 
  # using SHA1. 
  # We never store the actual password in the DB.
  def crypt_password
    write_attribute("salt", self.class.sha1("salt-#{Time.now}"))
    write_attribute "salted_password", self.class.salted_password(salt, self.class.sha1(password))
  end
    
  #before_update :crypt_unless_empty
  
  # If the record is updated we will check if the password is empty.
  # If its empty we assume that the user didn't want to change his
  # password and just reset it to the old value.
  def crypt_unless_empty
    user = self.class.find(self.id)
    write_attribute "salted_password", self.class.salted_password(user.salt, self.class.sha1(password)) if !password.empty? && user.password != self.password      
  end
  
  def self.salted_password(salt, hashed_password)
    sha1(salt + hashed_password)
  end
end

