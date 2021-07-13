extends "res://Scripts/Misc/Events/GenericEvent.gd"


export(String) var groupName = ""


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_TriggerEventByGroup_emit_event_triggered(by):
	get_tree().call_group(groupName, "trigger", by)
	pass # Replace with function body.
