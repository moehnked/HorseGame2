extends "res://Scripts/Misc/Events/GenericEvent.gd"

export(Color) var color = Color(1,1,1,1)
export(float, 0.0, 2.0) var rate = 0.01

func _on_UpdateGlobalLighting_emit_event_triggered(by):
	Global.SkyController.set_global_lighting(color, rate)
	pass # Replace with function body.
