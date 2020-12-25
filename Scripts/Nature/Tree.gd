extends Spatial

var hp:int = 25

func take_damage(dmg = 1, hitbox = null, source = null):
	hp -= dmg
	print(name, " hp: ", hp)
	if hp <= 0:
		fell()

func fell():
	Global.world.instantiate("res://prefabs/Nature/Stump.tscn", global_transform.origin)
	queue_free()
