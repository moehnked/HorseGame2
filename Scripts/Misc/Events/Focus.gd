extends "res://Scripts/Misc/Events/GenericEvent.gd"

var point

func parse_input(input):
	if input.engage or input.tab or input.forward or input.backward or input.left or input.right or input.space:
		stop()
		
func stop():
	var p = Global.Player
	p.get_head().unfocus()
	Global.InputObserver.unsubscribe(self)
	p.subscribe_to()
	p.get_interaction_controller().enable_interact()
	point.queue_free()
	queue_free()

func _on_Focus_emit_event_triggered(by):
	print("-------FOCUSING")
	point = Global.world.instantiate("res://prefabs/Misc/TestPoint.tscn", global_transform.origin + Vector3(0,0,0))
	Global.Player.get_head().unfocus()
	Global.Player.get_head().look_at_object(point)
	Global.InputObserver.clear()
	Global.InputObserver.subscribe(self)
	Global.Player.unsubscribe_to()
	$Timer.start()
	pass # Replace with function body.


func _on_Timer_timeout():
	stop()
	pass # Replace with function body.
