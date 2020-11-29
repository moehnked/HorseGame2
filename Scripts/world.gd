extends WorldEnvironment

export var music_enabled = true

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.world = self
	pass # Replace with function body.

func _process(delta):
	environment.background_sky.sun_latitude += 0.01

func create_point(point):
	var obj = load("res://prefabs/Misc/TestPoint.tscn").instance()
	obj.global_transform.origin = point
	add_child(obj)
	return obj
