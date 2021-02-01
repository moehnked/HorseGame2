extends "res://Scripts/Player/Palm_telegrapher.gd"


var og:Vector3 = Vector3()
var ang = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	og = self.transform.origin

func _process(delta):
	ang = wrapf(ang + 1 * delta, 0, 359)
	#print(sin(ang))
	self.transform.origin = og + Vector3(sin(ang), cos(ang), 0)
	pass
