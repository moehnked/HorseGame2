extends Area

onready var rootRef = get_tree().get_root().get_node("World")
export var songPath = "res://sounds/error_01.wav"
export var enabled = true

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_MusicTrigger_body_entered(body):
	if body == Global.Player and !Global.AudioManager.is_song_playing() and enabled:
		Global.AudioManager.play_song(songPath)
	pass # Replace with function body.
