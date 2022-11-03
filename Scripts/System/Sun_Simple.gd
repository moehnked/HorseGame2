extends Node


export(float, 0.1,5.0) var minuteInterval = 1.0
export(int) var minute = 0
export(int) var minuteRate = 3
export(int) var hour = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.Sun = self
	$Timer.wait_time = minuteInterval
	pass # Replace with function body.

func check_sky():
	pass

func get_hour():
	return hour

func get_minute():
	return minute

func increment_hour():
	print("Hour Tick: ", hour)
	minute = 0
	hour = (hour + 1) % 24
	Global.world.get_tree().call_group("HourAlert", "hour_alert", hour)

func increment_minute():
	minute += minuteRate
	if minute >= 60:
		increment_hour()

func _on_Timer_timeout():
	increment_minute()
	check_sky()
	pass # Replace with function body.
