class Instance < ActiveRecord::Base
  has_many :user_instances, :conditions => "active = 1"
  has_many :squares
  has_many :events  
  has_many :deeds
  has_one :setting
end
