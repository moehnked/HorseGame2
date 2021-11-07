extends "res://Scripts/Misc/Events/GenericEvent.gd"

export(String) var skyname = "day"

func _on_TransitionSky_emit_event_triggered(by):
	print("TransitionSky: triggered by ", by.name, by)
	Global.SkyController.set_sky(skyname)
	pass # Replace with function body.

