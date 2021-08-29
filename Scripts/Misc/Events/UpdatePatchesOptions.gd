extends "res://Scripts/Misc/Events/GenericEvent.gd"

export(Array, Resource) var options = []

func _on_UpdatePatchesOptions_emit_event_triggered(by):
	print("updating patches options")
	get_tree().call_group("Patches", "set_options", options)
	pass # Replace with function body.
