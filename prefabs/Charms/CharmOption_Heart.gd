extends Area2D
const hm = preload("res://Scripts/Statics/HorseMoods.gd")
const HorseMoods = hm.HorseMoods

export var charm = HorseMoods.heart
export var path = ""

func _ready():
	$TestSprite.set_texture(load(path))

func _on_MoodHeart_area_shape_entered(area_id, area, area_shape, self_shape):
	$Sprite.modulate = Color(0,1,0)
	owner.update_selected_charm(charm)
	pass # Replace with function body.


func _on_MoodHeart_area_shape_exited(area_id, area, area_shape, self_shape):
	$Sprite.modulate = Color(1,1,1)
	pass # Replace with function body.
