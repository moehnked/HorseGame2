extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Intro")
	pass # Replace with function body.

func create_game():
	add_child(load("res://prefabs/Casino/CardGames/Road.tscn").instance())

func play_sound(path):
	Global.AudioManager.play_sound(path)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
#	pass
