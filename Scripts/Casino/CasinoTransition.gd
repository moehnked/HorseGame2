extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.AudioManager.play_sound("res://Sounds/Cards_02.wav", -4)
	Global.AudioManager.play_song("res://Music/SweethandJack.wav", -15)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
