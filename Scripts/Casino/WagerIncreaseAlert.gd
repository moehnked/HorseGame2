extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("default")
	Global.AudioManager.play_sound("res://Sounds/Coins.wav", -10)
	pass # Replace with function body.

func initialize(text):
	$Label.text = "+" + String(text)
	pass
