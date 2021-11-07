extends "res://Scripts/Misc/Events/GenericEvent.gd"

export(int) var dialoguePoint = 0
export(NodePath) var targetNPC = null
export(String) var groupName

func get_target():
	if targetNPC != null:
		return get_node(targetNPC)
	else:
		var ar = Global.world.get_tree().get_nodes_in_group(groupName)
		return ar[0]

func _on_UpdateNPCDialoguePoint_emit_event_triggered(by):
	var o = get_target()
	if dialoguePoint == 0:
		o.increment_timeline()
	else:
		o.dialoguePoint = dialoguePoint
	pass # Replace with function body.
