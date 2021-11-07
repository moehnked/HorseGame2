extends Node2D

export var targetGroupName = "Road"

func play_sound(res, db = 0.0):
	Global.AudioManager.play_sound(res)
	
func call_game_method(method, gameGroup = targetGroupName):
	print("GameUI:",$AnimationPlayer.current_animation, ": calling ", method, " in ", gameGroup)
	Global.world.get_tree().call_group(gameGroup, method)

func instantiate(n):
	Global.world.add_child(n)
