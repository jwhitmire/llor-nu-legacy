class MasterRules < ActiveRecord::Migration
  def self.up
    settings = {
      :square_types => {:buyable => 70,:empty => 2, :quickies => 28},
      :quickie_payout => [100,400],
      :surprise_money => {:odds => 3,:payout => 5000},
      :special_items => {:duck => {:odds => 3, :range => [100,500]}, :hard_hat => {:odds => 1, :range => [1,10]}},
      :hotels => {:one_star => [2.0,1010,15],:two_star => [2.0,2020,20],:three_star => [2.0,3030,25],:four_star => [2.0,4040,30]},
      :public => true,
      :max_players => 0,
      :max_turns => 0,
      :daily_allowance => {:rate => 1000},
      :allow_debt => false
    }
    
    Setting.create(:value => settings, :instance_id => 1)
  end
  def self.down
    s = Setting.find(:all, :conditions => 'instance_id = 1')
    s.each do |row|
      row.destroy
    end
  end
end
