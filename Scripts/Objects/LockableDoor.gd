extends "res://Scripts/Interactables/Door_Generic.gd"

export(bool) var isLocked = true
export(NodePath) var key = null
var keyName = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	if key != null:
		keyName = get_node(key).get_name()
	pass # Replace with function body.

func get_prompt():
	return "Close" if isOpen else ("Open" if not isLocked else "Locked" + ("" if keyName == "" else " (Requires Key) "))

func lock():
	isLocked = true
	close()

func unlock():
	isLocked = false

func _on_Interactable_interaction(controller):
	var inv = controller.get_equipment_manager().get_inventory()
	if isOpen:
		toggle_open()
	else:
		if keyName != "":
			if Utils.contains(keyName, inv):
				toggle_open()
		elif not isLocked:
			toggle_open()
	pass # Replace with function body.
