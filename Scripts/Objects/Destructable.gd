extends StaticBody

signal emit_deconstruct()

export var effect_scale = 1.0

func deconstruct():
	spawn_prefab()
	spawn_materials()
	Global.AudioManager.play_sound_3d("res://Sounds/destroy_0" + str(Global.world.rng.randi_range(1,4)) +".wav", 0, global_transform.origin, 11)
	emit_signal("emit_deconstruct")
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
	obj.scale = Vector3(effect_scale,effect_scale,effect_scale)
