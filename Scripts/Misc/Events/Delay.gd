extends "res://Scripts/Misc/Events/GenericEvent.gd"

export(float, 0.0, 10.0) var timeDelay = 0.0
export(NodePath) var targetEvent

var triggerer

func _on_Delay_emit_event_triggered(by):
	$Timer.start(timeDelay)
	triggerer = by
	pass # Replace with function body.


func _on_Timer_timeout():
	get_node(targetEvent).trigger(triggerer)
	pass # Replace with function body.
