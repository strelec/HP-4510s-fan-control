HP 4510s, 4710s, 4410s customizable fan control
====

Since these machines are pretty old, they are not supported by `fancontrol` utility. Therefore, we have to write our own simple one.

These laptops have 6 fan speeds, that is 5 + turned off. If you take a quick look at `config.rb` file, you should notice

```ruby
Ranges = [
	[43,45], # 30
	[48,51], # 45
	[53,57], # 55
	[63,67], # 75
	[71,75], # 90
]
```

For each of the five speeds, you have two numbers. First one signifies when to slow down the fan if temperature falls below, second one signifies when to ramp up the fan if temperature exceeds it. Tune it to your liking.

Usage
---
Simply run `ruby fancontrol.rb` on the command line. You can add this line to your `initd` or `systemd` startup scripts.

The utility will provide a nice debug output.

Requirements
---
* as new version of Linux kernel as possible
* ruby >= 2.0
* lm_sensors
* acpi