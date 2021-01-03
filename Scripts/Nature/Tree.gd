extends Spatial

var hp:int = 25

func take_damage(dmg = 1, hitbox = null, source = null):
	hp -= dmg
	print(name, " hp: ", hp)
	if hp <= 0:
		fell()

func fell():
	Global.world.instantiate("res://prefabs/Nature/Stump.tscn", global_transform.origin)
	Global.world.instantiate("res://prefabs/Effects/TreeFell.tscn", global_transform.origin + Vector3(0,1,0))
	spawn_logs()
	queue_free()

func spawn_logs():
	var rng = Global.world.get_rng()
	var num = rng.randi_range(1,5)
	for i in range(0, num):
		var obj = Global.world.instantiate("res://prefabs/Items/Logs.tscn", global_transform.origin + Vector3(0,1,0))
		var rx = rng.randf()
		var rz = rng.randf()
		var dir = Vector3(rx, 1, rz).normalized()
		obj.linear_velocity = dir * 5
