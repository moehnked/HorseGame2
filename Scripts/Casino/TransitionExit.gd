extends "res://Scripts/Casino/GameUI.gd"

# Called when the node enters the scene tree for the first time.
func _ready():
	play_sound("res://Sounds/Cards_01.wav")
	pass # Replace with function body.


func _on_TransitionSuite_transition_end():
	$AnimationPlayer.play("cards")
	Global.Player.subscribe_to()
	pass # Replace with function body.
