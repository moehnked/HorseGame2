extends Node

export var music_enabled:bool = true
export(float, 0.0, 1.0) var sfxVolume = 1.0
export(float, 0.0, 1.0) var musicVolume = 1.0

var isFadingMusic = false
var curDB = 0.0
var dbFadeRate = 0.1
var prevDB = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.AudioManager = self
	pass # Replace with function body.

func _process(delta):
	if isFadingMusic:
		lerp_music()

func db_lerp(val):
	return 10 * log(val)

func fade_music(dbTo, rate = 0.1, restore = false):
	isFadingMusic = true
	curDB = dbTo if not restore else prevDB
	prevDB = get_current_music_volume()
	dbFadeRate = rate

func get_current_music_volume():
	return $MusicPlayer.volume_db

func is_song_playing():
	return $MusicPlayer.playing

func lerp_music():
	$MusicPlayer.volume_db = lerp($MusicPlayer.volume_db, curDB, dbFadeRate)
	if abs(curDB - $MusicPlayer.volume_db) < 0.2:
		isFadingMusic = false

func play_song(song_path = "res://sounds/error_01.wav", db = 0.0):
	if(music_enabled):
		#print("AudioManager: playing song ", song_path)
		queue_channel($MusicPlayer, song_path, db + db_lerp(musicVolume))

func play_sound(sound_path = "res://sounds/error_01.wav", db = 0, pitch = 1.0):
	db = db + db_lerp(sfxVolume)
	#print("queing sound at volume: ", db)
	if($AudioStreamPlayer.playing):
		if($AudioStreamPlayer2.playing):
			if($AudioStreamPlayer3.playing):
				return queue_channel($AudioStreamPlayer4, sound_path, db, pitch)
			else:
				return queue_channel($AudioStreamPlayer3, sound_path, db, pitch)
		else:
			return queue_channel($AudioStreamPlayer2, sound_path, db, pitch)
	else:
		return queue_channel($AudioStreamPlayer, sound_path, db, pitch)

func play_sound_3d(sound_path = "res://sounds/error_01.wav", db = 0, pos = Vector3(), size = 3):
	db = db + db_lerp(sfxVolume)
#	play_sound(sound_path, db)
#	return
	if $AudioStreamPlayer3D.playing:
		return queue_3d_channel($AudioStreamPlayer3D2, sound_path, db, pos, size)
	else:
		return queue_3d_channel($AudioStreamPlayer3D, sound_path, db, pos, size)

func queue_channel(channel = $AudioStreamPlayer, sound_path = "res://sounds/error_01.wav", db = 0, pitch = 1.0):
	#print("queing channel ", channel.name, " with VOLUME = ", db)
	channel.volume_db = db
	channel.stream = load(sound_path)
	channel.pitch_scale = pitch
	channel.play()
	return channel

func queue_3d_channel(channel = $AudioStreamPlayer3D, sound_path = "res://sounds/error_01.wav", db = 0, pos = Vector3(), size = 3):
	#print("executing sounds at vol - " , db)
	channel.stream = load(sound_path)
	channel.unit_db = db
	channel.global_transform.origin = pos
	channel.unit_size = size
	channel.play()
	return channel
