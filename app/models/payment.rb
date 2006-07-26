class Payment < ActiveRecord::Base
	belongs_to :user
	belongs_to :event
	belongs_to :deed	
	
	def self.recent_activity(user)
		Payment.find_by_sql ["
		    select payments.user_id as payer_id, 
		           events.user_id as payee_id,
		           payments.amount, 
		           payments.created_on, 
		           events.event_type_id, 
		           payee.name as payee 
		    from payments inner join events on payments.event_id = events.id 
		      inner join users as payee on events.user_id = payee.id 
		    where payments.user_id = ?
		    order by payments.created_on desc 
		    limit 0,40",user.id]
	end
end
