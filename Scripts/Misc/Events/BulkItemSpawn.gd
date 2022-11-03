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

func save():
	var o = {}
	for obj in objects.keys():
		o[obj.resource_path] = objects[obj]
	return Utils.serialize_node(self, {"objects": o})

func set(param, val):
	match param:
		"objects":
			for o in val.keys():
				objects[load(o)] = val[o]
		_:
			.set(param, val)
