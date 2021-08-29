extends "res://Scripts/Misc/Events/LoadTargetResource.gd"

export(String) var handEventGroupName = ""

func _on_LoadTargetResource_emit_event_triggered(by):
	var o = res.instance()
	Global.world.add_child(o)
	if o is Spatial:
		o.global_transform = global_transform
	o.set_event_group(handEventGroupName)
	if deletedTriggerer:
		by.queue_free()
	if deleteSelf:
		queue_free()
	pass # Replace with function body.
