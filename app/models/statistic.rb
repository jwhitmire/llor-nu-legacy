class Statistic
  def self.players(instance_id)
    UserInstance.count("instance_id = #{instance_id}")
  end
  def self.buildings(instance_id)
    Deed.count("instance_id = #{instance_id}")
  end
  def self.squares(instance_id)
    Square.count("instance_id = #{instance_id}")
  end
  def self.cash(user_instance_id)
    Account.sum(user_instance_id)
  end
  def self.buyable(instance_id)
    Square.buyable(instance_id)
  end
  def self.built(instance_id)
    Square.built(instance_id)
  end
  def self.quickies(instance_id)
    Square.quickies(instance_id)
  end
  def self.empties(instance_id)
    Square.empties(instance_id)
  end
end
