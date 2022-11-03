extends "res://Scripts/Misc/Events/GenericEvent.gd"

export(Array, Resource) var inventory = []
export(NodePath) var target

func update_inventory():
	#var ti = get_node(target).get_inventory()
	#var ti = get_node(target)
	var ti = get_node(target).get_equipment_manager()
	for i in inventory:
		#Utils.instance_item(i.instance()).interact(ti.get_equipment_manager(), not i.has_method("equip"))
		#ti.append(i.instance())
		ti.add_item(i.instance())


func _on_SetNPCInventory_emit_event_triggered(by):
	print("updating inventory for ", by.name)
	update_inventory()
	pass # Replace with function body.
