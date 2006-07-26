class Setting < ActiveRecord::Base
  serialize :value
  belongs_to :instance  
end
