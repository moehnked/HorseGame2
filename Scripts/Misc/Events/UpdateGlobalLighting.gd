extends "res://Scripts/Misc/Events/GenericEvent.gd"

export(Color) var color = Color(1,1,1,1)
export(bool) var fogEnabled = true
export(float, 0.0, 2.0) var rate = 0.01


func _on_UpdateGlobalLighting_emit_event_triggered(by):
	Global.SkyController.set_global_lighting(color, rate, fogEnabled)
	pass # Replace with function body.

func set_state(e):
	color = e['curcolor']
	rate = e['ltr']
	fogEnabled = e['fog']
	
