extends "res://Scripts/Misc/Events/GenericEvent.gd"


var patchesResource = preload("res://prefabs/Patches.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_SpawnerPatches_emit_event_triggered(by):
	var p = patchesResource.instance()
	Global.world.place(p, global_transform.origin)
	p.rotation_degrees.y = rotation_degrees.y
	by.queue_free()
	queue_free()
	pass # Replace with function body.
