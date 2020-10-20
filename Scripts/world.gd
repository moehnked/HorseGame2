extends Spatial

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func play_sound(sound_path = "res://sounds/error_01.wav", db = 0):
	$AudioStreamPlayer.volume_db = db
	$AudioStreamPlayer.stream = load(sound_path)
	$AudioStreamPlayer.play()
