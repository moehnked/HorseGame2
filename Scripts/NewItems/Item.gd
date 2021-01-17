extends RigidBody

export var icon = "res://icon.png"

var controller

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func add_self_to_inventory(_controller = controller):
	_controller.get_inventory().append(self)
	pass

func destroy():
	queue_free()

func get_context():
	return get_node("Context")

func get_icon(asTexture = false):
	return load(icon) if asTexture else icon

func get_name():
	return name

func interact(_controller):
	print("interacting")
	controller = _controller
	add_self_to_inventory(controller)
	pass

func _on_Interactable_interaction(controller):
	interact(controller)
	pass # Replace with function body.
