extends Spatial

var hp:int = 25
var nextHitSfx = preload("res://Sounds/wood_hit_01.wav")

func get_hit_sound():
	return "res://Sounds/wood_hit_0"+String(Global.world.rng.randi_range(0,2))+".wav"

func load_next_hit():
	print("playing sound TREEEE")
	nextHitSfx = load("res://Sounds/wood_hit_0"+String(Global.world.rng.randi_range(0,2))+".wav")

func take_damage(dmg = 1, hitbox = null, source = null):
	hp -= dmg
	print(name, " hp: ", hp)
	if hp <= 0:
		fell()

func fell():
	Global.world.instantiate("res://prefabs/Nature/Stump.tscn", global_transform.origin)
	Global.world.instantiate("res://prefabs/Effects/TreeFell.tscn", global_transform.origin + Vector3(0,1,0))
	Global.AudioManager.play_sound_3d("res://Sounds/tree_fall_01.wav", 0, global_transform.origin, 6)
	spawn_logs()
	queue_free()

func spawn_logs():
	var rng = Global.world.get_rng()
	var num = rng.randi_range(1,5)
	for i in range(0, num):
		var obj = Global.world.instantiate("res://prefabs/NewItems/Logs.tscn", global_transform.origin + Vector3(0,1,0))
		var rx = rng.randf()
		var rz = rng.randf()
		var dir = Vector3(rx, 1, rz).normalized()
		obj.linear_velocity = dir * 5
