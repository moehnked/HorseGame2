extends "res://Scripts/Misc/Events/GenericEvent.gd"

export(Resource) var res
export(bool) var deleteSelf = true
export(bool) var deletedTriggerer = true
export(bool) var isBackground = false

func load_target_resource(by):
	var o = res.instance()
	if isBackground:
		Global.world.add_child_ui(o)
	else:
		Global.world.add_child(o)
	if o is Spatial:
		o.global_transform = global_transform
	if deletedTriggerer:
		by.queue_free()
	if deleteSelf:
		queue_free()

func _on_LoadTargetResource_emit_event_triggered(by):
	load_target_resource(by)
	pass # Replace with function body.
