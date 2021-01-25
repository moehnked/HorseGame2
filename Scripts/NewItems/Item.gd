#Item.gd
extends RigidBody

export var icon = "res://icon.png"
export var itemName = "Item"
export var pickupSoundPath = "res://Sounds/pop_01.wav"

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
	return itemName

func interact(_controller):
	print("interacting")
	controller = _controller.get_equipment_manager()
	pickup(controller)
	pass

func pickup(_controller):
	print("[Item]:pickup")
	duplicate().add_self_to_inventory(_controller)
	#Utils.play_sound($Interactable/AudioStreamPlayer3D, pickupSoundPath)
	Global.AudioManager.play_sound(pickupSoundPath)
	destroy()

func _on_Interactable_interaction(controller):
	interact(controller)
	pass # Replace with function body.
