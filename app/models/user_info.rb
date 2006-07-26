class UserInfo < ActiveRecord::Base
	has_one :account
	has_many :deeds
	belongs_to :square
	belongs_to :payment
	#def self.table_name () "users" end
end