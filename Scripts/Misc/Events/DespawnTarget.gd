extends "res://Scripts/Misc/Events/GenericEvent.gd"


export(NodePath) var targetNode


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_DespawnTarget_emit_event_triggered(by):
	get_node(targetNode).queue_free()
	pass # Replace with function body.
