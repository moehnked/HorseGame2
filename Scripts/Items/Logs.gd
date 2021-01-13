extends "res://Scripts/Item.gd"

func _process(delta):
	global_transform.origin = get_parent().global_transform.origin
	pass
