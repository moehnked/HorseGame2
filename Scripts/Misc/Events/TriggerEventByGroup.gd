extends "res://Scripts/Misc/Events/GenericEvent.gd"

export(String) var groupName = ""

func _on_TriggerEventByGroup_emit_event_triggered(by):
	get_tree().call_group(groupName, "trigger", by)
	pass # Replace with function body.
