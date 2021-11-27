extends "res://Scripts/Misc/Events/GenericEvent.gd"


export(String) var methodName = ""
export(NodePath) var target
export(Dictionary) var args = {}


func _on_CallMethodsOnTarget_emit_event_triggered(by):
	if args.values().size() == 0:
		get_node(target).call(methodName)
	else:
		get_node(target).call(methodName, args.values())
	pass # Replace with function body.
