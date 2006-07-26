class Deed < ActiveRecord::Base
	acts_as_list :scope => :user
	belongs_to :user
	belongs_to :instance
	belongs_to :square
	belongs_to :property_type
	has_many :payments
	
	def rent
		self.property_type.rent(self.levels)
	end
	
	def cost_to_upgrade(level)
		self.property_type.cost(level)-self.property_type.cost(self.levels)
	end

	def cost_to_sell(level)
		i=self.property_type.cost(self.levels)-self.property_type.cost(level)
		(i.to_f*0.9).to_i
	end
	def total_revenue
		self.payments.inject(0) { |sum, n| sum + (n.amount > 0 ? n.amount : 0) }
	end
	
	def before_validation
	  self.levels ||= 1
	end
	
	validates_length_of :name, :maximum => 255, :allow_nil => true
	validates_presence_of :square_id
	validates_presence_of :levels # a deed must have levels!
  validates_each :levels do |record,attr|
    record.errors.add attr, ' is not valid' if !record[attr].nil? and record[attr] < 1
  end
  def self.decay(instance)
    self.update_all("health = health -1","instance_id = #{instance.id}")
  end
end
