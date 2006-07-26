class Message < ActiveRecord::Base
	belongs_to :square, :counter_cache => true
	belongs_to :user
	belongs_to :instance
	
	# grandfather instance_id into any creation of new records (saves a lot of jiggery pokery)
  before_validation {|record| record.instance_id = $INSTANCE_ID}	

  def self.count_since(id)
    self.count(['id > ?', id])
  end

  validates_presence_of :message
  validates_length_of :message, :minimum => 3

end
