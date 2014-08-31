# CONFIG
# HP 4510s has 6 speeds (5 + turned off). For each speed, specify [A, B],
# where A is temperature to turn off the speed if CPU temp falls below,
# and B is a point to turn on speed if CPU temp exceeds it.

Ranges = [
	[43,45], # 30
	[48,51], # 45
	[53,57], # 55
	[63,67], # 75
	[71,75], # 90
]