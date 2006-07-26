# The methods added to this helper will be available to all templates in the application.
module ApplicationHelper

	# this is a stupid stop gap fix for the localization crap
#	def l(string)
#		return string
#	end

	def display_balance 
		string = ""
    if @user.user_instance.account.balance <= 0
			string += "No cash."
		else
			string += number_with_delimiter(@user.user_instance.account.balance)
		end
	end
	def payment_text(event)
		case
			when event.event_type_id.to_i == 8 then
				string = "You paid #{event.payee} #{event.amount.abs} #{time_ago_in_words event.created_on} ago."
			when event.event_type_id.to_i == 2 then
				string = "You bought a building for #{event.amount.abs} #{time_ago_in_words event.created_on} ago."
			when event.event_type_id.to_i == 3 then
				string = "You used real money to buy #{event.amount.abs} #{time_ago_in_words event.created_on} ago."
			when event.event_type_id.to_i == 4 then
				string = "You sold a level for #{event.amount.abs} #{time_ago_in_words event.created_on} ago."
			when event.event_type_id.to_i == 5 then
				string = "You upgraded a level for #{event.amount.abs} #{time_ago_in_words event.created_on} ago."
			when event.event_type_id.to_i == 6 then
				string = "The game gave you #{event.amount.abs} #{time_ago_in_words event.created_on} ago."
			when event.event_type_id.to_i == 7 then
				string = "You spent #{event.amount.abs} on building maintenance #{time_ago_in_words event.created_on} ago."
			when event.event_type_id.to_i == 1 then
				string = "#{event.payee} paid you #{event.amount.abs} #{time_ago_in_words event.created_on} ago."
			when event.event_type_id.to_i == 9 then
				string = "You found #{event.amount.abs} #{time_ago_in_words event.created_on} ago."
			when event.event_type_id.to_i == 10 then
				string = "You won #{event.amount.abs} #{time_ago_in_words event.created_on} ago at a Quicky."
			when event.event_type_id.to_i == 11 then
				string = "#{event.payee} paid you #{event.amount.abs} #{time_ago_in_words event.created_on} ago."
			else
				string = "An undescribed event gave you #{event.amount.abs} #{time_ago_in_words event.created_on} ago."
		end
		return string
	end
	def payment_row(event)
		case
			when event.event_type_id.to_i == 8 then
				string = "<td align=\"right\">Paid Rent</td><td><span style=\"color:red;\">-#{event.amount.abs}</span></td><td>#{event.payee}</td><td>#{time_ago_in_words event.created_on} ago.</td>"
			when event.event_type_id.to_i == 2 then
			  string = "<td align=\"right\">Bought Building</td><td><span style=\"color:red;\">-#{event.amount.abs}</span></td><td>&nbsp;</td><td>#{time_ago_in_words event.created_on} ago.</td>"			
			when event.event_type_id.to_i == 4 then
			  string = "<td align=\"right\">Sold Level</td><td><span style=\"color:green;\">#{event.amount.abs}</span></td><td>&nbsp;</td><td>#{time_ago_in_words event.created_on} ago.</td>"
			when event.event_type_id.to_i == 5 then
			  string = "<td align=\"right\">Bought Level</td><td><span style=\"color:red;\">-#{event.amount.abs}</span></td><td>&nbsp;</td><td>#{time_ago_in_words event.created_on} ago.</td>"
			when event.event_type_id.to_i == 6 then
			  string = "<td align=\"right\">Allowance</td><td><span style=\"color:green;\">#{event.amount.abs}</span></td><td>Bank</td><td>#{time_ago_in_words event.created_on} ago.</td>"				
			when event.event_type_id.to_i == 7 then
			  string = "<td align=\"right\">Maintenance</td><td><span style=\"color:red;\">-#{event.amount.abs}</span></td><td>Bank</td><td>#{time_ago_in_words event.created_on} ago.</td>"
			when event.event_type_id.to_i == 1 then
			  string = "<td align=\"right\">Received Rent</td><td><span style=\"color:green;\">#{event.amount.abs}</span></td><td>#{event.payee}</td><td>#{time_ago_in_words event.created_on} ago.</td>"
			when event.event_type_id.to_i == 9 then
			  string = "<td align=\"right\">Found</td><td><span style=\"color:green;\">#{event.amount.abs}</span></td><td>&nbsp;</td><td>#{time_ago_in_words event.created_on} ago.</td>"
			when event.event_type_id.to_i == 10 then
			  string = "<td align=\"right\">Won</td><td><span style=\"color:green;\">#{event.amount.abs}</span></td><td>&nbsp;</td><td>#{time_ago_in_words event.created_on} ago.</td>"
			when event.event_type_id.to_i == 11 then
			  string = "<td align=\"right\">Hard Hat Destruction</td><td><span style=\"color:green;\">#{event.amount.abs}</span></td><td><span style=\"color:#666;\">By:</span> #{event.payee}</td><td>#{time_ago_in_words event.created_on} ago.</td>"
			when event.event_type_id.to_i == 12 then
			  string = "<td align=\"right\">Hard Hat Proceeds</td><td><span style=\"color:green;\">#{event.amount.abs}</span></td><td><span style=\"color:#666;\">Against:</span> #{event.payee}</td><td>#{time_ago_in_words event.created_on} ago.</td>"
			else
			  string = "<td align=\"right\">&nbsp;</td><td>#{event.amount}</td><td>&nbsp;</td><td>#{time_ago_in_words event.created_on} ago.</td>"
		end
		return string
	end
	
	def start_bubble_wrap(foreground_color,background_color,id=nil)
	  if id
	    id_string = " id = \"#{id}\""
	  else
	    id_string = ""
	  end
	  
	  <<-YOINK
	  <div class="#{foreground_color}_on_#{background_color}_wrapper" #{id_string}>
		  <div class="#{foreground_color}_on_#{background_color}_header"><ul><li>&nbsp;</li></ul></div>
			<div id="content">
	  YOINK
	end
  def end_bubble_wrap(foreground_color,background_color)
    <<-YOINK
	  </div>
	  <div class="#{foreground_color}_on_#{background_color}_footer"><ul><li>&nbsp;</li></ul></div>
	  </div>
	  YOINK
  end
end
