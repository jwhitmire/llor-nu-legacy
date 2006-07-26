class Game

def self.integrity_check(options={})
puts " * Checking deeds"
deeds=Deed.count
deeded_squares=Square.count("deeds_count = 1 ")
player_owned_squares=Square.count("square_type_id = 2 ")
deeds_valid=true
if (deeds != deeded_squares )
  puts " [WARN] Number of deeds and deeded squares do not match"
  puts "        #{deeds} actual Deed objects, but #{deeded_squares} deeded squares"
  deeds_valid=false
end
if (deeds != player_owned_squares)
  puts " [WARN] Number of deeds and player owned squares do not match"  
  puts "        #{deeds} actual Deed objects, but #{player_owned_squares} player owned squares"
  deeds_valid=false
end

if options[:repair] and not deeds_valid
  Square.find(:all).each do |square|
    if square.deed
      if not square.deeds_count==1 or not square.square_type_id==2
	square.deeds_count=1
	square.square_type_id==2
	square.save!
      end
    else
      if square.deeds_count==1 or square.square_type_id==2
	square.deeds_count=0
	square.square_type_id==3
	square.save!
      end
    end
  end
end

puts " * Checking accounts"

accounts=Account.count
players=User.count

if (players!=accounts)
  puts " [WARN] Number of Players does not match # of Accounts"
  puts "        There are #{players} players and #{accounts} accounts."
end
end
def self.account_fix
  users = User.find(:all)
  users.each do |user|
    if not user.account
      a = Account.new
      a.user_id = user.id
      a.balance = 5000
      a.save      
    end
  end
end
def self.dupe_player_fix
  # find all duped logins
  users = User.find_by_sql('SELECT login, count(*) as n from users GROUP BY login HAVING n > 1')
  
  users.each do |user|
    # find the first login created
    duplicates = User.find(:all, :conditions => ['login = ?',user.login], :order => 'created_on DESC')
    keep = duplicates.pop
    duplicates.each do |dupe|
      dupe.destroy
    end
  end
end
def self.delete_orphaned_deeds
  deeds = Deed.find_by_sql('select deeds.* from users right join deeds on users.id = user_id where users.id is null')
  deeds.each do |deed|
    deed.destroy
  end
end
def self.delete_orphaned_accounts
  accounts = Account.find_by_sql('select accounts.* from users right join accounts on users.id = user_id where users.id is null')
  accounts.each do |account|
    account.destroy
  end
end
def self.delete_duped_accounts
  accounts = Account.find_by_sql('SELECT *, count(*) as n from accounts GROUP BY user_id HAVING n > 1 order by created_on')
  
  accounts.each do |account|
    # find the account with the most dough
    duplicates = Account.find(:all, :conditions => ['user_id = ?',account.user_id], :order => 'balance DESC')
    keep = duplicates.pop
    duplicates.each do |dupe|
      dupe.destroy
    end
  end  
end
def self.balance_buyable
  # this is nasty, but it's about the only way I can accuractely remove squares without players on them
  buyable = Square.find(:all, :conditions => ['square_type_id = ?',3],:limit => 1000)
  buyable.each do |square|
    # trans
    if User.find(:all, :conditions => ['square_id = ?',square.id]).size > 0
    else
      square.destroy
    end
    # run this just in case things have dipped below the threshold
    Square.doler
  end
end
def self.delete_instance(instance_id)
  # delete squares
  squares = Square.find(:all, :conditions => ['instance_id',instance_id])
  squares.each do |square|
    square.destroy
  end
    
  # delete accounts
  accounts = Account.find_by_sql("select * from accounts inner join user_instances on user_instances.id = accounts.user_instance_id where user_instances.instance_id = #{instance_id}")
  accounts.each do |account|
    account.destroy
  end
    
  # delete user items
  user_items = UserItem.find_by_sql("select * from user_items inner join user_instances on user_instances.id = user_items.user_instance_id where user_instances.instance_id = #{instance_id}")
  # delete user/instance associations
  user_instances = UserInstance.find_by_sql("select * from user_instances where instance_id = #{instance_id}")
  
  # delete deeds
  deeds = Deed.find_by_sql("select * from deeds where instance_id = #{instance_id}")
  deeds.each do |deed|
    deed.destroy
  end
  # delete events and payments
  events = Event.find_by_sql("select * from events inner join user_instances on user_instances.id = events.user_instance_id where user_instances.instance_id = #{instance_id}")
  events.each do |event|
    event.payments.each do |payment|
      payment.destroy
    end
    event.destroy
  end
  # delete messages
  
  # delete the instance
  Instance.find(instance_id).destroy
end

def self.daily(instance)
  if instance.setting.value["building_decay"].to_i != 0
    # decay buildings
    Deed.decay(instance)
  end

  # add funds to all users
  if instance.setting.value["daily_allowance"]["rate"].to_i != 0
    users = User.find_by_sql("select users.id from users inner join user_instances on user_instances.user_id = users.id where user_instances.instance_id = #{instance.id}")

    users.each do |join_user|
      user = User.find(join_user.id)
      event = Event.create(:user_id => user.id, :event_type_id => 6, :user_instance_id => user.user_instance.id)
      Payment.create(:user_id => user.id, :amount => instance.setting.value["daily_allowance"]["rate"].to_i, :event_id => event.id)
      user.user_instance.account.balance += instance.setting.value["daily_allowance"]["rate"].to_i
      user.save(false)
    end
  end
end

end
