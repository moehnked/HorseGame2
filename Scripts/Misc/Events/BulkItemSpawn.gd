extends "res://Scripts/Misc/Events/GenericEvent.gd"

export var objects = {}

func _on_GenericEvent_emit_event_triggered(by):
	pass # Replace with function body.

func spawn_objects():
	for o in objects.keys():
		for i in range(objects[o]):
			var ob = o.instance()
			Global.world.add_child(ob)
			ob.global_transform.origin = global_transform.origin
			if ob is RigidBody:
				ob.add_central_force(Vector3(Global.world.rng.randf_range(-1,1),10,Global.world.rng.randf_range(-1,1)))
