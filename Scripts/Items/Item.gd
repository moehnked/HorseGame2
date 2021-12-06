#Item.gd
extends RigidBody



export(Array, Context.Context) var ContextOptions
export var icon = "res://icon.png"
export var itemName = "Item"
export var pickupSoundPath = "res://Sounds/pop_01.wav"
export var value = 5.0

const HB = preload("res://Scripts/Horse/Behaviors/HorseBehavior.gd")

var canBePickedUp = true
var controller

func add_self_to_inventory(_controller = controller):
	_controller.add_item(self)
	pass

func destroy():
	queue_free()

func get_behavior():
	print("GETTING BEHAVIOR FROM ", get_name())
	print(get_children())
	for i in get_children():
		if i is HB:
			return i
	return null

func get_context():
	return get_node("Context")

func get_description(asString = true):
	return get_node("Description").get_description() if asString else get_node("Description")

func get_icon(asTexture = false):
	return load(icon) if asTexture else icon

func get_mesh():
	for i in get_children():
		if i is MeshInstance:
			return i
	return MeshInstance.new()

func get_name():
	return itemName

func get_value():
	return value

func interact(_controller):
	print("interacting")
	controller = _controller.get_equipment_manager()
	pickup(controller)
	pass

func is_item():
	return true

func pickup(_controller):
	print(name,":picked up by ",_controller.get_parent().name)
	controller = _controller
	if controller.has_method("get_equipment_manager"):
		controller = controller.get_equipment_manager()
	duplicate(7).add_self_to_inventory(controller)
	Global.AudioManager.play_sound(pickupSoundPath)
	destroy()

func set_pickup_sound(sound_path):
	pickupSoundPath = sound_path

func set_interactable(state = true, matchPromptState = false):
	$Interactable.set_interactable(state, matchPromptState)

func _on_Interactable_interaction(controller):
	interact(controller)
	pass # Replace with function body.
