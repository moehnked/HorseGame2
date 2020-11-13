extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	
	print("HERE I AM ", global_transform.origin)
	pass # Replace with function body.

func is_test_point():
	return true


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
