extends Node

export var music_enabled:bool = true
export var sfxVolume = 1.0


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.AudioManager = self
	pass # Replace with function body.


func is_song_playing():
	return $MusicPlayer.playing

func play_song(song_path = "res://sounds/error_01.wav", db = 0.0):
	if(music_enabled):
		queue_channel($MusicPlayer, song_path, db)

func play_sound(sound_path = "res://sounds/error_01.wav", db = 0):
	db = db * sfxVolume
	print("queing sound at volume: ", db)
	if($AudioStreamPlayer.playing):
		if($AudioStreamPlayer2.playing):
			if($AudioStreamPlayer3.playing):
				return queue_channel($AudioStreamPlayer4, sound_path, db)
			else:
				return queue_channel($AudioStreamPlayer3, sound_path, db)
		else:
			return queue_channel($AudioStreamPlayer2, sound_path, db)
	else:
		return queue_channel($AudioStreamPlayer, sound_path, db)

func play_sound_3d(sound_path = "res://sounds/error_01.wav", db = 0, pos = Vector3(), size = 3):
	db = db * sfxVolume
#	play_sound(sound_path, db)
#	return
	if $AudioStreamPlayer3D.playing:
		return queue_3d_channel($AudioStreamPlayer3D2, sound_path, db, pos, size)
	else:
		return queue_3d_channel($AudioStreamPlayer3D, sound_path, db, pos, size)

func queue_channel(channel = $AudioStreamPlayer, sound_path = "res://sounds/error_01.wav", db = 0):
	print("queing channel ", channel.name, " with VOLUME = ", db)
	channel.volume_db = db
	channel.stream = load(sound_path)
	channel.play()
	return channel

func queue_3d_channel(channel = $AudioStreamPlayer3D, sound_path = "res://sounds/error_01.wav", db = 0, pos = Vector3(), size = 3):
	print("executing sounds at vol - " , db)
	channel.stream = load(sound_path)
	channel.unit_db = db
	channel.global_transform.origin = pos
	channel.unit_size = size
	channel.play()
	return channel
