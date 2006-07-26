class Event < ActiveRecord::Base
	has_many :payments
	belongs_to :user
	belongs_to :user_instance	
end