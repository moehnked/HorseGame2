extends "res://Scripts/Misc/Events/GenericEvent.gd"


export(Array, Resource) var options = []


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_UpdatePatchesOptions_emit_event_triggered(by):
	print("updating patches options")
	get_tree().call_group("Patches", "set_options", options)
	pass # Replace with function body.
