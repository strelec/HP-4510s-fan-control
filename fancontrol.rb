# HP 4510s fan control
# REQUIREMENTS (pretty standard):
# as new version of linux kernel as possible
# ruby >= 2.0
# lm_sensors
# acpi


# CONFIG
# HP 4510s has 6 speeds (5 + turned off). For each speed, specify [A, B],
# where A is temperature to turn off the speed if CPU temp falls below,
# and B is a point to turn on speed if CPU temp exceeds it.

ranges = [
	[43,45], # 30
	[48,51], # 45
	[53,57], # 55
	[63,67], # 75
	[71,75], # 90
]

# SCRIPT (do not modify!)

class Array
	def average
		reduce(:+) / size
	end
end

class String
	def assert
		raise this unless yield
	end
end

def device(n)
	"/sys/devices/virtual/thermal/cooling_device#{n}/cur_state"
end

def setbit(n, val)
	File.write(device(8-n), val.to_s)
	File.write(device(15-n), val.to_s)
end

def set(level)
	5.times { |i|
		setbit(i, (i<=level)?1:0 )
	}
end

def get
	`acpi -t`[/(\d?\d\.\d) degrees/, 1].to_i
end

def sensors
	2.times.map { |i|
		`sensors`[/Core #{i}:\s+\+(\d\d\.\d)°C/, 1].to_f
	}
end

def temperature
	sensors.reduce(:+) / 2
end

def raw
	(3..15).map { |i|
		"/sys/devices/virtual/thermal/cooling_device#{i}/cur_state"
	}.map { |f|
		File.read(f).to_i
	}.join
end

mins = ranges.map(&:first)
maxs = ranges.map(&:last)

"Turn off temeratures out of order".assert {
	mins.sort == mins
}
"Turn on temeratures out of order".assert {
	maxs.sort == maxs
}
"Turn off speed higher than turn on speed".assert {
	mins.last <= maxs.last
}

current = 0
loop {
	temp = Array.new(10) {
		set current
		sleep 1
		temperature
	}.average

	pinpoint = -> points {
		points.index { |s|
			temp <= s
		} || points.size
	}

	current = [pinpoint[maxs], current].max
	current = [pinpoint[mins], current].min

	puts "#{raw} #{get}/#{current} #{temp}"
}