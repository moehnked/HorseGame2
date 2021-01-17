extends Node

var canInteract = true
var canReadPrompt:bool = true
var equipmentManager = null
var ignore = []
var interactables = []
var interactable
var raycast:RayCast = RayCast.new()

signal broadcast_self(controller)
signal emit_looking_at(by, at)

func _ready():
	emit_signal("broadcast_self", self)

func _process(delta):
	read_prompt()
	if interactable != null:
		if interactable.has_method("recieve_looking_at"):
			interactable.recieve_looking_at(self)
		emit_signal("emit_looking_at",self,interactable)
	var obj = raycast.get_collider()
	if obj != null:
		print(obj.name)
	if obj != null and check_if_ignore(obj):
		if obj.has_method("interact"):
			if obj.isInteractable:
				interactable = obj
				return
	interactable = null
	enable_can_read()

func add_to_ignore(other):
	ignore.append(other)
	pass

func begin_dialogue(other):
	owner.enter_dialogue(other)

func check_if_ignore(other):
	if ignore.has(other):
		return false
	if other.get_parent() != null:
		if ignore.has(other.get_parent()):
			return false
	return true

func clear():
	Global.InteractionPrompt.clear()

func disable_interact():
	canInteract = false

func enable_interact():
	canInteract = true

func enable_can_read():
	canReadPrompt = true

func get_equipment_manager():
	return equipmentManager

func get_looking_at():
	return interactable

func set_raycast(_raycast):
	raycast = _raycast

func parse_input(input):
	if input.engage and canInteract:
		if interactable != null:
			if interactable.isInteractable:
				interactable.interact(equipmentManager)
				Global.world.queue_timer(self, 5.0, "enable_can_read")
				canReadPrompt = false
				clear()

func read_prompt():
	if canInteract and interactable != null and canReadPrompt:
		Global.InteractionPrompt.show_prompt(interactable.prompt(), interactable.has_method("is_low"))
	else:
		clear()

func remove_from_ignore(item):
	ignore.erase(item)
	return item

func subscribe_to():
	Global.InputObserver.subscribe(self)

func toggle_interactability():
	canInteract = !canInteract

func _on_RayCast_Areas_broadcast_self(_raycast):
	raycast = _raycast
	pass # Replace with function body.

func _on_EquipmentManager_broadcast_self(manager):
	equipmentManager = manager
	pass # Replace with function body.


func _on_EquipmentManager_emit_equipped(equipment):
	add_to_ignore(equipment)
	pass # Replace with function body.


func _on_EquipmentManager_emit_unequip(equipment):
	remove_from_ignore(equipment)
	pass # Replace with function body.
