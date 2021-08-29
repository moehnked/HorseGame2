extends "res://Scripts/Misc/Events/GenericEvent.gd"

export(String) var groupName = ""

func _on_DeloadTargetgroup_emit_event_triggered(by):
	Global.world.get_tree().call_group(groupName, "queue_free")
	pass # Replace with function body.
