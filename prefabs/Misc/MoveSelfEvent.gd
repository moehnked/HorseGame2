extends "res://Scripts/Misc/Events/GenericEvent.gd"

export(Vector3) var offset
export(float,-10,10) var weight

var isMoving = false
var goalPos

func _ready():
	goalPos = global_transform.origin + offset

func _process(delta):
	if isMoving:
		global_transform.origin = global_transform.origin.linear_interpolate(goalPos, weight)
	
	
func trigger(by):
	isMoving = true
	.trigger(by)
	pass


