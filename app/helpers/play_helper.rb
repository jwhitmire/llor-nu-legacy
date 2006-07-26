module PlayHelper
#	include Paypal::Helpers
	
	def pagination_links_with_ajax(paginator, options={})
		options.merge!(ActionView::Helpers::PaginationHelper::DEFAULT_OPTIONS) {|key, old, new| old}
		window_pages = paginator.current.window(options[:window_size]).pages

		return if window_pages.length <= 1 unless
			options[:link_to_current_page]
			first, last = paginator.first, paginator.last
			returning html = '' do
				if options[:always_show_anchors] and not window_pages[0].first?
					#html << link_to(first.number, options[:name] => first)
					html << link_to_remote(first.number, :update => options[:element_name], :url => { :action => options[:action], :page => first })
					html << ' ... ' if window_pages[0].number - first.number > 1
					html << ' '
				end

				window_pages.each do |page|
					if paginator.current == page && !options[:link_to_current_page]
						html << page.number.to_s
					else
						#html << link_to(page.number, options[:name] => page)
						html << link_to_remote(page.number, :update => options[:element_name], :loading => options[:loading], :complete => options[:complete], :url => { :action => options[:action], :page => page })
					end
				html << ' '
			end

			if options[:always_show_anchors] && !window_pages.last.last?
				html << ' ... ' if last.number - window_pages[-1].number > 1
				#html << link_to(paginator.last.number, options[:name] => last)
				html << link_to_remote(last.number, :update => options[:element_name], :url => { :action => options[:action], :page => last })
			end
		end
	end
	
	def draw_building(levels,type,id=nil)
		top = -42
		left = -45
		adjust = 38
		offset = ((20 * 6)+adjust) - (levels * 6)+top
		html = ''
		building_height = 0
		
		if levels > 1
			html <<	"<div style=\"position:absolute;top:0px;z-index:0\"><img src=\"/images/#{type}/top.png\" width=\"65\" height=\"38\" border=\"0\" /></div>"
			building_height = 22
		end
		
		level_top = 0
		level_count = -1		
		levels.times do
			html << "<div style=\"position:absolute;top:#{level_top}px;z-index:#{level_count}\"><img src=\"/images/#{type}/middle.png\" width=\"65\" height=\"39\" border=\"0\" /></div>"					
			level_count -= 1
			level_top += 6
			building_height += 6
		end
				
		html <<	"<div style=\"position:absolute;top:#{level_top}px;z-index:#{level_count}\"><img src=\"/images/#{type}/bottom.png\" width=\"65\" height=\"53\" border=\"0\" /></div>"
		building_height += 45
		if id != nil
			html << "<div style=\"position:absolute;top:0px;left:0px;height:#{building_height}px;\">"
			html << "<a href=\"#\" onmouseover=\"bubbleShow('bubble#{id}');\" onmouseout=\"bubbleHide('bubble#{id}');\"><img src=\"/images/invisible.png\" width=\"65\" height=\"#{building_height}\" border=\"0\" /></a>"
			html << "</div>"
		end
		
		return html
	end
	def draw_building_top(levels,type,boss_top,id=nil)
		top = -42
		left = -45
		adjust = 38
		offset = ((20 * 6)+adjust) - (levels * 6)+top
		html = ''
		building_height = 0
		
		if levels > 1
			html <<	"<div style=\"position:absolute;top:#{boss_top}px;z-index:0\"><img src=\"/images/#{type}/top.png\" width=\"65\" height=\"38\" border=\"0\" /></div>"
			building_height = 22
		end
		
		level_top = 0 + boss_top
		level_count = -1		
		levels.times do
			html << "<div style=\"position:absolute;top:#{level_top}px;z-index:#{level_count}\"><img src=\"/images/#{type}/middle.png\" width=\"65\" height=\"39\" border=\"0\" /></div>"					
			level_count -= 1
			level_top += 6
			building_height += 6
		end
				
		html <<	"<div style=\"position:absolute;top:#{level_top}px;z-index:#{level_count}\"><img src=\"/images/#{type}/bottom.png\" width=\"65\" height=\"53\" border=\"0\" /></div>"
		building_height += 45
		if id != nil
			html << "<div style=\"position:absolute;top:0px;left:0px;height:#{building_height}px;\">"
			html << "<a href=\"#\" onmouseover=\"bubbleShow('bubble#{id}');\" onmouseout=\"bubbleHide('bubble#{id}');\"><img src=\"/images/invisible.png\" width=\"65\" height=\"#{building_height}\" border=\"0\" /></a>"
			html << "</div>"
		end
		
		return html
	end
end
