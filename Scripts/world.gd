extends WorldEnvironment

export var music_enabled = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	environment.background_sky.sun_latitude += 0.01

func create_point(point):
	var obj = load("res://prefabs/Misc/TestPoint.tscn").instance()
	obj.global_transform.origin = point
	add_child(obj)
	print("creating point to wander to at ", point, " - ", obj.global_transform.origin)
	return obj

func is_song_playing():
	return $MusicPlayer.playing

func play_song(song_path = "res://sounds/error_01.wav", db = 0.0):
	if(music_enabled):
		queue_channel($MusicPlayer, song_path, db)

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
