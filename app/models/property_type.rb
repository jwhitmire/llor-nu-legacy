class PropertyType < ActiveRecord::Base
	has_one :deed
	acts_as_list

	def rent(level)
		level*self.level_modifier	
	end

	def cost(level)
		adj=(level/2.0)*(level+1)
		(level*self.position*1010)+(level*self.level_modifier)-(adj*self.level_modifier).to_i
	end
	# this is embarrassing actually. i'm writing this knowing that assocation extensions are a much better way. this will be fixed soon
	def self.get_max_levels(property_type_id,user)
    case property_type_id
    when 2
      user.user_instance.instance.setting.value["hotels"]["one_star"][2]
    when 1
      user.user_instance.instance.setting.value["hotels"]["two_star"][2]
    when 3
      user.user_instance.instance.setting.value["hotels"]["three_star"][2]
    when 4
      user.user_instance.instance.setting.value["hotels"]["four_star"][2]
    end
	end
end
