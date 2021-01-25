extends StaticBody

func deconstruct():
	spawn_prefab()
	spawn_materials()
	queue_free()
	pass

func spawn_materials():
	var rng = Global.world.rng
	var l = rng.randi_range(1,5)
	var obj = load("res://prefabs/Items/Plank.tscn")
	for i in range(l):
		var v = obj.instance()
		Global.world.call_deferred("add_child", v)
		v.global_transform.origin = global_transform.origin + Vector3(rng.randi_range(-2,2),2,rng.randi_range(-2,2))
		pass

func spawn_prefab():
	var obj = load("res://prefabs/Effects/deconstruct.tscn").instance()
	Global.world.call_deferred("add_child", obj)
	obj.global_transform.origin = global_transform.origin + Vector3(0,2,0)
