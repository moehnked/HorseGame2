extends "res://Scripts/Misc/Events/GenericEvent.gd"

export(bool) var removeAfterDelay = false
export(NodePath) var targetEvent
export(float) var timeDelay = 0.0



var triggerer

func _on_Delay_emit_event_triggered(by):
	$Timer.start(timeDelay)
	triggerer = by
	pass # Replace with function body.


func _on_Timer_timeout():
	var n = get_node(targetEvent)
	if n != null:
		n.trigger(triggerer)
	if removeAfterDelay:
		Utils.report_node_deletion(self)
		queue_free()
	pass # Replace with function body.

