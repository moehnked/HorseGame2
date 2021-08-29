extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func toggle(pause = true):
	print("testParentProcess: ", pause)
	self.pause_mode = PAUSE_MODE_STOP if pause else PAUSE_MODE_INHERIT
