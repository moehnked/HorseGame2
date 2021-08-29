extends "res://Scripts/Misc/Events/GenericEvent.gd"

export(Array, Resource) var inventory = []
export(NodePath) var target

func update_inventory():
	var ti = get_node(target).get_inventory()
	for i in inventory:
		ti.append(i.instance())


func _on_SetNPCInventory_emit_event_triggered(by):
	print("updating inventory for ", by.name)
	update_inventory()
	pass # Replace with function body.
