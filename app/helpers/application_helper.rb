module ApplicationHelper

	def fix_url url
		url.starts_with?("http://") ? url : "http://#{url}" 
	end

	def friendly_datetime dt

    return "" if dt.nil?

    tz = logged_in? && !current_user.time_zone.blank? ? 
         current_user.time_zone : Time.zone.name
    
		dt.in_time_zone(tz).strftime("%H:%M:%S %Z %e-%b-%Y")
	end

end
