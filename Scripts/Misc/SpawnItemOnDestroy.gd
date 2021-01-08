extends Spatial

export var hp = 1
export var pathToEffect = "res://prefabs/Effects/SimpleBurst.tscn"
export var pathToPrefab = "res://prefabs/Items/Item.tscn"

func take_damage(dmg = 1, hitbox = null, source = null):
	print("[Logs]: taking ",dmg, " damage")
	hp -= dmg
	if hp <= 0:
		spawn_prefab()

func spawn_prefab():
	Global.world.instantiate(pathToEffect, global_transform.origin)
	Global.world.instantiate(pathToPrefab, global_transform.origin)
	queue_free()
	pass
