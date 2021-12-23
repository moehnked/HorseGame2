extends "res://Scripts/System/broadcast_self.gd"

var equipmentManager = null
var interactables = []
var ignore = []
var pepTimer = Timer.new()

func _ready():
	ignore.append(self)
	ignore.append(get_parent())
	ignore.append(get_parent().get_node("Interactable"))
	emit_signal("broadcast_self", self)
	initialize_timers()

func _process(delta):
	if interactables.size() > 0:
		interact_with(interactables.pop_front())

func add_to_ignore(other):
	ignore.append(other)

func get_equipment_manager():
	return equipmentManager

func initialize_timers():
	pass

func interact_with(other):
	if get_parent().isInteractingWith:
		other.interact(self)
	pass

func pep_tick():
	pass

func _on_InteractionController_area_entered(area):
	if area.has_method("interact"):
		if not ignore.has(area):
			interactables.append(area)
	pass # Replace with function body.


func _on_InteractionController_body_entered(body):
	if body.has_method("interact") and not body.has_method("is_item"):
		if not ignore.has(body):
			interactables.append(body)
	pass # Replace with function body.


func _on_EquipmentManager_broadcast_self(obj):
	equipmentManager = obj
	pass # Replace with function body.
