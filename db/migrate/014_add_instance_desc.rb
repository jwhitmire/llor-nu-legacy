class AddInstanceDesc < ActiveRecord::Migration
  def self.up
    add_column :instances, :description, :string, :limit => 300
    i = Instance.find(1)
    i.description = "The original massive game."
    i.save
  end
  def self.down
    remove_column :instances, :description
  end
end
