extends "res://Scripts/Misc/Events/GenericEvent.gd"

func _on_DeloadStartingCave_emit_event_triggered(by):
	var tree = Global.world.get_tree()
	tree.call_group("StartingCave", "queue_free")
	pass # Replace with function body.
