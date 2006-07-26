class UserInstance < ActiveRecord::Base
  belongs_to :instance
  has_one :user
  has_one :account
  has_many  :user_items
  
  def self.join_or_create(user_id,instance_id)
    if self.find(:first, :conditions => "user_id = #{user_id} AND instance_id = #{instance_id}")
      ### JOIN ###
      # before deactivating, grab the user's current square and tack it on to the current user/instance
      square_id = User.find(user_id).square_id
      self.update_all("square_id = #{square_id}","user_id = #{user_id} and active = 1")
      
      # deactiveate all other instances
      self.update_all("active = 0","user_id = #{user_id}")      
      # make this one active
      self.update_all("active = 1","user_id = #{user_id} and instance_id = #{instance_id}")
      square_id = self.find(:first,:conditions => "user_id = #{user_id} AND active = 1").square_id
      
      # update the user's square
      User.update_all("square_id = #{square_id}","id = #{user_id}")
    else
      self.update_all("active = 0","user_id = #{user_id}")
      ### CREATE ###
      settings = Setting.find(:first,:conditions => "instance_id = #{instance_id}").value
      # create a new record, make it active      
      user_instance = self.create(:user_id => user_id,:instance_id => instance_id, :active => 1)
      # create an account and first items since they're new to this instance
      Account.create(:user_id => user_id,:balance => settings["starting_balance"], :user_instance_id => user_instance.id)
      UserItem.create(:user_id => user_id, :item_id => settings["special_items"]["starting_items"]["duck"]["id"], :uses_left => settings["special_items"]["starting_items"]["duck"]["uses_left"], :active => 1, :apply_mode => 1, :user_instance_id => user_instance.id)
      
      # set the first position to user table. this only changes when the user leaves this instance an enters another
      square_id = User.first_position(user_id,instance_id)
      self.update_all("square_id = #{square_id}","user_id = #{user_id} and instance_id = #{instance_id}")
      User.update_all("square_id = #{square_id}","id = #{user_id}")
    end
  end
  def self.check(user_id,instance_id)
    self.find(:first, :conditions => "user_id = #{user_id} AND instance_id = #{instance_id}")
  end
end
