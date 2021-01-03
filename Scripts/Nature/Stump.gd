extends StaticBody

var hp:int = 5
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func take_damage(dmg = 1, hitbox = null, source = null):
	hp -= dmg
	print(name, " hp: ", hp)
	if hp <= 0:
		fell()

func fell():
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
