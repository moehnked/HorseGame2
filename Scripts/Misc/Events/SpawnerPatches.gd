extends "res://Scripts/Misc/Events/GenericEvent.gd"

var patchesResource = preload("res://prefabs/Patches.tscn")

func _on_SpawnerPatches_emit_event_triggered(by):
	var p = patchesResource.instance()
	Global.world.place(p, global_transform.origin)
	p.rotation_degrees.y = rotation_degrees.y
	by.queue_free()
	queue_free()
	pass # Replace with function body.
