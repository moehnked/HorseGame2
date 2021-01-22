extends "res://Scripts/Items/Throwable.gd"

func take_damage(dmg = 1, hitbox = null, source = null):
	if dmg == 100 and !isEquipped:
		if source.has_method("grind_fossil"):
			if source.grind_fossil(self):
				spawn_effect()
				queue_free()

func spawn_effect():
	Global.world.instantiate("res://prefabs/Effects/TrophyShatter.tscn", global_transform.origin)
	pass
