extends "res://Scripts/Misc/Events/GenericEvent.gd"

export(Resource) var res
export(bool) var deleteSelf = true
export(bool) var deletedTriggerer = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_LoadTargetResource_emit_event_triggered(by):
	var o = res.instance()
	add_child(o)
	if deletedTriggerer:
		by.queue_free()
	if deleteSelf:
		queue_free()
	pass # Replace with function body.
