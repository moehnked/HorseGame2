#Item.gd
extends RigidBody



export(Array, Context.context) var ContextOptions
export var icon = "res://icon.png"
export var itemName = "Item"
export var pickupSoundPath = "res://Sounds/pop_01.wav"
export var value = 5.0

const HB = preload("res://Scripts/Horse/Behaviors/HorseBehavior.gd")

var canBePickedUp = true
var controller
var originalPath = null
var originalParentPath = null

func _ready():
	print("Item: ", name, " ready, adding to group")
	add_to_group("Persist")
	if originalPath == null:
		originalPath = get_path()
		originalParentPath = get_parent().get_path()

func add_self_to_inventory(_controller = controller, exitTree = false):
	_controller.add_item(self)
	if exitTree and get_parent() != null:
		get_parent().remove_child(self)
	pass

func deload():
	var p = get_parent()
	var o = owner
	if p != null:
		p.remove_child(self)
	if owner != null:
		owner.remove_child(self)
	owner = null

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

func get_controller():
	if controller is String:
		controller = Global.world.get_node(controller)
		if controller != null:
			return controller
		else:
			for n in get_tree().get_nodes_in_group("EquipmentManagers"):
				if Utils.contains_unique(self, n.get_inventory()):
					controller = n
					return controller
			return null
	else:
		return controller

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

func get_original_path():
	return originalPath

func get_parent_original_path():
	return originalParentPath

func get_value():
	return value

func interact(_controller):
	print("interacting")
	controller = _controller.get_equipment_manager()
	Utils.reparent(self, Global.world)
	pickup(controller)
	pass

func is_item():
	return true

func pickup(_controller):
	print(name,":picked up by ",_controller.get_parent().name)
	controller = _controller
	if controller.has_method("get_equipment_manager"):
		controller = controller.get_equipment_manager()
	#duplicate(7).
	add_self_to_inventory(controller)
	Global.AudioManager.play_sound(pickupSoundPath)
	#destroy()
	deload()

func save():
	return Utils.serialize_node(self, {"controller":get_controller().get_path() if get_controller() != null else null })

func set(param, val):
	match param:
		"controller":
			if val is String:
				var n = Global.world.get_node(val)
				if n != null:
					self.owner.add_child(self) if self.owner != null else Global.world.add_child(self)
					#n.add_item(self)
					#self.owner.remove_child(self)
				.set(param, n)
			else:
				.set(param, null)
		"ContextOptions":
			pass
		_:
			.set(param, val)

func set_pickup_sound(sound_path):
	pickupSoundPath = sound_path

func set_interactable(state = true, matchPromptState = false):
	$Interactable.set_interactable(state, matchPromptState)

func toggle_collisions(enabl = true):
	for i in get_children():
		if i is CollisionShape:
			i.disabled = not enabl

func _on_Interactable_interaction(controller):
	interact(controller)
	pass # Replace with function body.
