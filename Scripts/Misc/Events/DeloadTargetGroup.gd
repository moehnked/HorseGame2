extends "res://Scripts/Misc/Events/GenericEvent.gd"

export(String) var groupName = ""

func _on_DeloadTargetgroup_emit_event_triggered(by):
	#Global.world.get_tree().call_group(groupName, "queue_free")
	var groupNodes = Global.world.get_tree().get_nodes_in_group(groupName)
	for n in groupNodes:
		var no = n.owner
		if no != null:
			if no.has_method("record_node_delete"):
				no.call("record_node_delete", n)
		n.queue_free()
	
	pass # Replace with function body.
