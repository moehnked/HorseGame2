extends "res://Scripts/Misc/Events/GenericEvent.gd"


export var scenePath = "res://prefabs/UI/MainMenu.tscn"

func _on_TransitionScene_emit_event_triggered(by):
	get_tree().change_scene(scenePath)
	pass # Replace with function body.
