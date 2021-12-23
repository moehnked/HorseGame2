extends Node

export var music_enabled:bool = true
export(float, 0.0, 5.0) var sfxVolume = 1.0
export(float, 0.0, 1.0) var musicVolume = 1.0
export(Array, AudioStream) var normal_tracks

var ambiFadeRate = 0.1
var curDB = 0.0
var dbFadeRate = 0.1
var isFadingAmbiance = false
var isFadingMusic = false
var noMusicTicks = 0
var prevDB = 0.0
var prevSong
var targetDB = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.AudioManager = self
	pass # Replace with function body.

func _process(delta):
	if isFadingMusic:
		lerp_music()
	if isFadingAmbiance:
		lerp_amb()

func db_lerp(val):
	return 10 * log(val)

func fade_music(dbTo, rate = 0.1, restore = false):
	isFadingMusic = true
	curDB = dbTo if not restore else prevDB
	prevDB = get_current_music_volume()
	dbFadeRate = rate

func get_current_music_volume():
	return $MusicPlayer.volume_db

func hour_alert():
	if not is_song_playing() and music_enabled:
		noMusicTicks -= 1
		if noMusicTicks <= 0:
			$MusicPlayer.stream = Utils.get_random(normal_tracks)
			$MusicPlayer.play()
#			var s = Utils.get_random(normal_tracks)
#			if s != prevSong:
#				prevSong = s
#				play_song()
			noMusicTicks = Global.world.rng.randi_range(2,20)
		pass
		

func is_song_playing():
	return $MusicPlayer.playing

func lerp_amb():
	$AmbiancePlayer.volume_db = lerp($AmbiancePlayer.volume_db, targetDB, ambiFadeRate)
	if abs(targetDB - $AmbiancePlayer.volume_db) < 0.2:
		isFadingMusic = false

func lerp_music():
	$MusicPlayer.volume_db = lerp($MusicPlayer.volume_db, curDB, dbFadeRate)
	if abs(curDB - $MusicPlayer.volume_db) < 0.2:
		isFadingMusic = false

func play_ambiance(ambi, tdb = 0.0, fadeRate = 0.1, from = -1):
	if ambi is String:
		ambi = load(ambi)
	$AmbiancePlayer.stream = ambi
	if not $AmbiancePlayer.playing:
		$AmbiancePlayer.volume_db = -100
	targetDB = tdb
	isFadingAmbiance = true
	ambiFadeRate = fadeRate
	$AmbiancePlayer.play((Global.world.rng.randf_range(0,ambi.get_length())) if from < 0 else from)
	pass

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
	if sound_path is String:
		sound_path = load(sound_path)
	channel.volume_db = db
	channel.stream = sound_path
	channel.pitch_scale = pitch
	channel.play()
	return channel

func queue_3d_channel(channel = $AudioStreamPlayer3D, sound_path = "res://sounds/error_01.wav", db = 0, pos = Vector3(), size = 3):
	#print("executing sounds at vol - " , db)
	if sound_path is String:
		sound_path = load(sound_path)
	channel.stream = sound_path
	channel.unit_db = db
	channel.global_transform.origin = pos
	channel.unit_size = size
	channel.play()
	return channel

func set_music_volume(val):
	print("AudioManage: Updating music volume: ", val)
	musicVolume = val
	$MusicPlayer.volume_db = db_lerp(val)

func set_sfx_volume(val):
	sfxVolume = val

func stop_ambiance():
	isFadingAmbiance = true
	targetDB = -100
