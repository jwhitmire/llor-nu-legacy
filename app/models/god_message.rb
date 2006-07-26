class GodMessage < ActiveRecord::Base
  def self.latest
    self.find(:first, :order => 'created_on DESC')
  end
end
