extends "res://Scripts/Interactables/Door_Generic.gd"

export(NodePath) var key = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Interactable_interaction(controller):
	var inv = controller.get_equipment_manager().get_inventory()
	if isOpen:
		toggle_open()
	else:
		if key != null:
			var k = get_node(key)
			if Utils.contains(k, inv):
				toggle_open()
	pass # Replace with function body.
