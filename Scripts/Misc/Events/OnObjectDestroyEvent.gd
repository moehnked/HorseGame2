extends "res://Scripts/Misc/Events/GenericEvent.gd"

export(NodePath) var watching = null
export(String) var objectName = ""
export(NodePath) var eventToTrigger
export(bool) var destroyOnTrig = true

func triggerer_destroyed(by):
	print("matching object destroyed")
	if eventToTrigger != null:
		get_node(eventToTrigger).trigger(by)
	if destroyOnTrig:
		queue_free()

func _on_GenericEvent_emit_event_triggered(by):
	if watching != null:
		var o = get_node(watching)
		if by == o:
			triggerer_destroyed(by)
	elif objectName != "":
		if by.name == objectName:
			triggerer_destroyed(by)
	pass # Replace with function body.
