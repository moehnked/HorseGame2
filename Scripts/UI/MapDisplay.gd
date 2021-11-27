extends Control

var hasMap = false
var mapVisible = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if Input.is_action_just_released("mapToggle"):
		toggle()

func _process(delta):
	var pp =  Global.Player.global_transform.origin
	$ColorRect/Sprite/MapPointer.position = Vector2(pp.x, pp.z) * 0.5

func toggle():
	visible = !visible
	
