extends "res://Scripts/Misc/Events/GenericEvent.gd"

export(NodePath) var targetDoor


func effect_door(by):
	var d = get_node(targetDoor)
	d.lock()
	#by.queue_free()
	#queue_free()


func _on_LockTargetDoor_emit_event_triggered(by):
	effect_door(by)
	pass # Replace with function body.
