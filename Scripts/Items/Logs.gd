extends "res://Scripts/Item.gd"

func _process(delta):
	global_transform.origin = owner.global_transform.origin
