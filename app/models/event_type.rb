class EventType < ActiveRecord::Base
	has_one :event
	#def self.table_name () "mem_event_types" end
end