module ApplicationHelper

	def fix_url url
		url.starts_with?("http://") ? url : "http://#{url}" 
	end

	def friendly_datetime dt
		dt.nil? ? "" : dt.strftime("%H:%M:%S %Z %e-%b-%Y")
	end

end
