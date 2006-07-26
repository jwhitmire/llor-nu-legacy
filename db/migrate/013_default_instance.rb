class DefaultInstance < ActiveRecord::Migration
  def self.up
    Instance.create :name => 'Master Instance', :user_id => 1
    
    users = User.find(:all)
    instance = Instance.find(1)
    users.each do |user|
      user.instances << instance
    end
    
    Account.update_all ("instance_id = 1")
    Deed.update_all ("instance_id = 1")
    Event.update_all ("instance_id = 1")    
    Message.update_all ("instance_id = 1")
    Payment.update_all ("instance_id = 1")    
    Score.update_all ("instance_id = 1")
    Square.update_all ("instance_id = 1")
    UserItem.update_all ("instance_id = 1")
  end
  def self.down
    Account.update_all ("instance_id = NULL")
    Deed.update_all ("instance_id = NULL")
    Event.update_all ("instance_id = NULL")
    Message.update_all ("instance_id = NULL")
    Payment.update_all ("instance_id = NULL")    
    Score.update_all ("instance_id = NULL")
    Square.update_all ("instance_id = NULL")
    UserItem.update_all ("instance_id = NULL")
  end
end
