extends "res://Scripts/Misc/Events/GenericEvent.gd"

export(float, 0.0, 20.0) var lockTime = 2.0
export(bool) var deleteAfterFocus = true

var point
var stopped = true
export var hardLock = false

func parse_input(input):
	if (input.engage or input.tab or input.forward or input.backward or input.left or input.right or input.space) and not hardLock:
		stop()
		
func stop():
	if not stopped:
		stopped = true
		print("Event: Focus: ------ STOPPING")
		var p = Global.Player
		p.get_head().unfocus()
		Global.InputObserver.unsubscribe(self)
		p.subscribe_to()
		p.get_interaction_controller().enable_interact()
		if point != null:
			point.queue_free()
		if deleteAfterFocus:
			queue_free()

func _on_Focus_emit_event_triggered(by):
	print("-------FOCUSING")
	stopped = false
	#point = Global.world.instantiate("res://prefabs/Misc/TestPoint.tscn", global_transform.origin + Vector3(0,0,0))
	Global.Player.get_head().unfocus()
	Global.Player.get_head().look_at_object(self)
	Global.InputObserver.clear()
	Global.InputObserver.subscribe(self)
	Global.Player.unsubscribe_to()
	$Timer.start(lockTime)
	pass # Replace with function body.


func _on_Timer_timeout():
	stop()
	pass # Replace with function body.
