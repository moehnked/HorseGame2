extends Node2D

export var val = 0.0
export var loadinResPath = "res://prefabs/Casino/Backdrop.tscn"
export var unloadGroupName = ""

func _ready():
	$AnimationPlayer.play("Fadein")
	

func _process(delta):
	$Sprite.material.set_shader_param("value", lerp($Sprite.material.get_shader_param("value"), val, 0.1))

func loadin_next():
	if loadinResPath != "":
		Global.world.add_child(load(loadinResPath).instance())
	elif unloadGroupName != "":
		Global.world.get_tree().call_group(unloadGroupName, "queue_free")
	pass
