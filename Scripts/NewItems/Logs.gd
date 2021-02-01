#Log.gd
extends "res://Scripts/Items/Item.gd"

export var hp = 1
export var pathToEffect = "res://prefabs/Effects/SimpleBurst.tscn"
export var pathToPrefab = "res://prefabs/Items/Plank.tscn"
export var sfx:String = "res://Sounds/wood_hit_split_01.wav"

func take_damage(dmg = 1, hitbox = null, source = null):
	print("[Logs]: taking ",dmg, " damage")
	hp -= dmg
	Global.AudioManager.call_deferred("play_sound",sfx, -5)
	if hp <= 0:
		spawn_prefab()
		queue_free()

func spawn_prefab():
	Global.world.instantiate(pathToEffect, global_transform.origin)
	Global.world.instantiate(pathToPrefab, global_transform.origin)

func split():
	var i = Global.world.rng.randi_range(1,8)
	Global.AudioManager.call_deferred("play_sound","res://Sounds/snap_01.wav", -5)
	while i > 0:
		spawn_prefab()
		i -= 1
	queue_free()
