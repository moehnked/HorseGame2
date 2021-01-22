extends StaticBody

var hp:int = 5
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_hit_sound():
	return "res://Sounds/wood_hit_0"+String(Global.world.rng.randi_range(0,2))+".wav"

func take_damage(dmg = 1, hitbox = null, source = null):
	hp -= dmg
	print(name, " hp: ", hp)
	if hp <= 0:
		fell()

func fell():
	Global.AudioManager.play_sound_3d("res://Sounds/snap_01.wav", 0, global_transform.origin)
	spawn_logs()
	queue_free()

func spawn_logs():
	var rng = Global.world.get_rng()
	var num = 1
	for i in range(0, num):
		var obj = Global.world.instantiate("res://prefabs/Items/Logs.tscn", global_transform.origin + Vector3(0,1,0))
		var rx = rng.randf()
		var rz = rng.randf()
		var dir = Vector3(rx, 1, rz).normalized()
		obj.linear_velocity = dir * 5
