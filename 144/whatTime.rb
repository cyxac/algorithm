def what_time seconds
	hour = seconds / 3600
	min = seconds % 3600 / 60
	sec = seconds % 60
	return "#{hour}:#{min}:#{sec}"
end

what_time 0
what_time 3661
what_time 5436
what_time 86399