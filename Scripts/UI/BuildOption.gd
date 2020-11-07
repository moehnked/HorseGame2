extends Area2D

var prefab = ""
var prev = null
var selected = false

func get_prefab():
	return prefab

func initialize(type, builder):
	prefab = type
	$Sprite.texture = load("res://Sprites/UI/BE_" + prefab + ".png")

func _on_BuildOption_area_shape_entered(area_id, area, area_shape, self_shape):
	$Sprite.modulate = Color(0,1,0)
	pass # Replace with function body.


func _on_BuildOption_area_shape_exited(area_id, area, area_shape, self_shape):
	$Sprite.modulate = Color(1,1,1)
	pass # Replace with function body.
