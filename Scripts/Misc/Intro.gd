extends Node2D

export var firstScenPath = "res://prefabs/UI/MainMenu.tscn"

var scene

func _ready():
	scene = load(firstScenPath)
	print(scene)


func _process(delta):
	if(!$VideoPlayer.is_playing()):
		print("DONE")
		goto_next_scene()
	if Input.is_action_just_released("ui_cancel") or Input.is_action_just_released("ui_accept") or Input.is_action_just_released("standard"):
		goto_next_scene()

func goto_next_scene():
	get_tree().change_scene_to(scene)
	pass
