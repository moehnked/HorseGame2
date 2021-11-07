extends DirectionalLight

var time = {
	"hour":12,
	"meridiem":"AM"
}

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.Sun = self
	pass # Replace with function body.

func _process(delta):
	rotation_degrees.x = lerp_angle(rotation_degrees.x, rotation_degrees.x + 10, 0.1)

func clamp_clock(val):
	return int(floor(val)) % 12

func update_meridiem():
	if Utils.between(floor(360 - int(rotation_degrees.x) % 360), 90, 270):
		time.meridiem = "AM"
	else:
		time.meridiem = "PM"

func _on_SunTickTimer_timeout():
	#rotation_degrees.x += 0.01
	var rot = rotation_degrees.x
	var hour = clamp_clock(floor((rot / 15)) - 6)
	if time.hour != hour:
		time.hour = hour
		#print(rotation_degrees.x,"]the time is ",time.hour,":00 ", time.meridiem)
	update_meridiem()
	$SunTickTimer.start()
	pass # Replace with function body.
