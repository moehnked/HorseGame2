extends Spatial

onready var rootRef = get_tree().get_root().get_node("World")

func _ready():
	subscribe_to()
	pass # Replace with function body.

func subscribe_to():
	rootRef.get_node("InputObserver").subscribe(self)

func unsubscribe_to():
	rootRef.get_node("InputObserver").unsubscribe(self)
	
func parse_input(input):
	rotate_x(input.mouse_vertical)
	rotation.x = clamp(rotation.x, deg2rad(-90), deg2rad(90))
