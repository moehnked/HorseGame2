extends "res://Scripts/Misc/Events/GenericEvent.gd"

export(NodePath) var targetDoor

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_LockTargetDoor_emit_event_triggered(by):
	var d = get_node(targetDoor)
	d.lock()
	by.queue_free()
	queue_free()
	pass # Replace with function body.
