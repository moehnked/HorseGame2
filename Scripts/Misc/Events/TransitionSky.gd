extends "res://Scripts/Misc/Events/GenericEvent.gd"

export(Dictionary) var Skygroups

func _on_TransitionSky_emit_event_triggered(by):
	Global.world.get_tree().call_group("Skymesh", "begin_fadeout")
	for s in Skygroups.keys():
		print("sky-transition: ", s, "  transitioning")
		Global.world.get_tree().call_group(s, "begin_fadein", Skygroups[s])
	pass # Replace with function body.
