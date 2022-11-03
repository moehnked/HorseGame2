extends "res://Scripts/Misc/Events/GenericEvent.gd"

export(Dictionary) var args = {}
export(NodePath) var A_Event
export(NodePath) var B_Event
export(Resource) var evaluatorScriptRef

var evarScript

func _on_A_B_Switch_emit_event_triggered(by):
	var e = evaluatorScriptRef.evaluate(args)
	if e:
		get_node(A_Event).trigger(self)
	else:
		get_node(B_Event).trigger(self)
	pass # Replace with function body.
