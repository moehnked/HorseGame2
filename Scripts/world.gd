extends Spatial

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func play_sound(sound_path = "res://sounds/error_01.wav", db = 0):
	if($AudioStreamPlayer.playing):
		if($AudioStreamPlayer2.playing):
			queue_channel($AudioStreamPlayer3, sound_path, db)
		else:
			queue_channel($AudioStreamPlayer2, sound_path, db)
	else:
		queue_channel($AudioStreamPlayer, sound_path, db)

func queue_channel(channel = $AudioStreamPlayer, sound_path = "res://sounds/error_01.wav", db = 0):
	print("queing channel ", channel.name)
	channel.volume_db = db
	channel.stream = load(sound_path)
	channel.play()
