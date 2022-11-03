extends Spatial

var hr = 0
var minute = 720
var MaxMinutes = 1440
var rotPerc = 0.25
var skyMode = "day"
var lightLevel = 1.0
var colorLevel = Color(0,0,0,1)
export(float, -100, 100) var thresh = 1.0
export(float, -1, 1) var weight = 0.0


# Called when the node enters the scene tree for the first minute.
func _ready():
	Global.Sun = self
	pass # Replace with function body.

func _process(delta):
	$DirectionalLight.rotation_degrees.x = lerp($DirectionalLight.rotation_degrees.x, $DirectionalLight.rotation_degrees.x + thresh, weight)
	$DirectionalLight.rotation_degrees.x = Utils.wrap($DirectionalLight.rotation_degrees.x, -90, 270)
	minute = (int(floor(($DirectionalLight.rotation_degrees.x + 90) * 4)) + 720) % 1440
	check_sky()

func check_sky():
	#print_time_of_day(minute)
	var h = get_hour(minute)
	if h > hr:
		print("Hour Tick: ", h)
		Global.world.get_tree().call_group("HourAlert", "hour_alert", h)
	hr = h
	if hr > 3 and skyMode == "night":
#		print("day starting")
#		skyMode = "day"
#		Global.SkyController.set_sky(skyMode)
#		Global.SkyController.set_global_lighting(Color(1,1,1,1), 0.001, false)
		lightLevel = 1.0
	if minute >= 900 and skyMode == "day":
#		print("evening starting")
#		skyMode = "late"
#		Global.SkyController.set_sky(skyMode)
#		Global.SkyController.set_global_lighting(Color(0.1,0,0,1), 0.001, false)
		lightLevel - 0.5
	if minute >= 1100 and skyMode == "late":
#		print("night starting")
#		skyMode = "night"
#		Global.SkyController.set_sky(skyMode)
#		Global.SkyController.set_global_lighting(Color(0,0,0.15,1), 0.001, false)
		lightLevel = 0.1
	$DirectionalLight.light_energy = lerp($DirectionalLight.light_energy, lightLevel, 0.1)
#	pass

func get_hour(m):
	return int(floor(m / 60)) + 1

func get_merideam(m):
	return (m > 720)

func get_minute():
	return minute

func get_time_of_day():
	var hr = get_hour(minute)
	return String(int(floor(hr % 12))) + ":" +  String(int(floor(minute)) % 60) + " " + ("PM" if get_merideam(minute) else "AM")


func increment_minute():
	minute += 1
	if minute >= 1440:
		minute = 0
	#$DirectionalLight.rotate_x(deg2rad(rotPerc))

func print_time_of_day(m):
	var hr = get_hour(m)
	print(int(floor(hr % 12)),":", int(floor(m)) % 60, " ", ("PM" if get_merideam(m) else "AM"))

func _on_tick_timeout():
	increment_minute()
	check_sky()
	$tick.start()
	pass # Replace with function body.
