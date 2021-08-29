extends "res://Scripts/Misc/Events/GenericEvent.gd"

export(String) var methodName = ""
export(String) var targetGroup = ""
export(Dictionary) var args = {}

func _on_GenericEvent_emit_event_triggered(by):
	get_tree().call_group(targetGroup, "callv", methodName, args.values())
	pass # Replace with function body.
