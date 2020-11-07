extends Node2D

export var firstScenPath = "res://world.tscn"

func _process(delta):
	if(!$VideoPlayer.is_playing()):
		print("DONE")
		get_tree().change_scene(firstScenPath)
