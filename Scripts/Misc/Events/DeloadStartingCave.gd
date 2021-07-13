extends "res://Scripts/Misc/Events/GenericEvent.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.




func _on_DeloadStartingCave_emit_event_triggered(by):
	var tree = Global.world.get_tree()
	tree.call_group("StartingCave", "queue_free")
	pass # Replace with function body.
