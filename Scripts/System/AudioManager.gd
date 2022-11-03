extends Node

export var music_enabled:bool = true
export(float, 0.0, 5.0) var sfxVolume = 1.0
export(float, 0.0, 1.0) var musicVolume = 1.0
export(Array, AudioStream) var normal_tracks
export(Array, AudioStream) var ambiant_tracks

var ambiFadeRate = 0.1
var curDB = 0.0
var dbFadeRate = 0.1
var erSoundPath = "res://Sounds/error.wav"
var hour = 0
var isFadingAmbiance = false
var isFadingMusic = false
var musicLimitLoop = false
var musicLoops = 0
var musicPosition = 0.0
var noMusicTicks = 0
var prevDB = 0.0
var prevSong
var targetDB = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.AudioManager = self
	pass # Replace with function body.
	

func _process(delta):
	check_music_position()
	for n in get_tree().get_nodes_in_group("AudioQueue"):
		n.call("play_sound", n.get_queue())
		n.remove_from_group("AudioQueue")
	if isFadingMusic:
		lerp_music()
	if isFadingAmbiance:
		lerp_amb()

func check_music_position():
	var pos = $MusicPlayer.get_playback_position()
	if pos < musicPosition:
		song_end()
	musicPosition = pos
	pass

func db_lerp(val):
	return 10 * log(val)

func fade_music(dbTo, rate = 0.1, restore = false):
	isFadingMusic = true
	curDB = dbTo if not restore else prevDB
	prevDB = get_current_music_volume()
	dbFadeRate = rate

func get_current_music_volume():
	return $MusicPlayer.volume_db

func hour_alert(_hour):
	hour = _hour
	if not is_song_playing() and music_enabled:
		noMusicTicks -= 1
		if noMusicTicks <= 0:
			$MusicPlayer.stream = Utils.get_random(normal_tracks)
			$MusicPlayer.play()
			fade_music(prevDB, 0.01)
			noMusicTicks = Global.world.rng.randi_range(2,17)
		pass
		

func increment_step(gtype = "Dirt", stepScale = 12):
	$FootstepManager.increment_step(gtype, stepScale)

func is_song_playing():
	return $MusicPlayer.playing

func lerp_amb():
	$AmbiancePlayer.volume_db = lerp($AmbiancePlayer.volume_db, targetDB, ambiFadeRate)
	if abs(targetDB - $AmbiancePlayer.volume_db) < 0.2:
		isFadingAmbiance

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

func play_footstep(gtype = "Dirt"):
	$FootstepManager.step(gtype)

func play_song(song_path = erSoundPath, db = 0.0):
	if(music_enabled):
		musicPosition = 0.0
		musicLoops = 0
		#print("AudioManager: playing song ", song_path)
		#queue_channel($MusicPlayer, song_path, db + db_lerp(musicVolume))
		queue_channel($MusicPlayer, song_path, db)

func play_sound(sound_path = erSoundPath, db = 0, pitch = 1.0):
	#db = db + db_lerp(sfxVolume)

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

func play_sound_3d(sound_path = erSoundPath, db = 0, pos = Vector3(), size = 3):
	#db = db + db_lerp(sfxVolume)

	if $AudioStreamPlayer3D.playing:
		return queue_3d_channel($AudioStreamPlayer3D2, sound_path, db, pos, size)
	else:
		return queue_3d_channel($AudioStreamPlayer3D, sound_path, db, pos, size)

func queue_channel(channel = $AudioStreamPlayer, sound_path = erSoundPath, db = 0, pitch = 1.0):
	if sound_path is String:
		sound_path = load(sound_path)
	channel.volume_db = db
	channel.stream = sound_path
	channel.pitch_scale = pitch
	channel.play()
	return channel

func queue_3d_channel(channel = $AudioStreamPlayer3D, sound_path = erSoundPath, db = 0, pos = Vector3(), size = 3):
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
	#$MusicPlayer.volume_db = db_lerp(val)
	AudioServer.set_bus_volume_db(2, db_lerp(val))

func set_sfx_volume(val):
	sfxVolume = val
	AudioServer.set_bus_volume_db(1, db_lerp(val))

func song_end():
	print("song end")
	if $MusicPlayer.stream.get_loop_mode() == 1:
		print("looped song ended")
		musicLoops += 1
		if musicLoops >= 1 and not musicLimitLoop:
			print("looped at least once, might terminate")
			#flip coin, if fail then song will start fading out
			var f = Utils.rand_float_range(0.0, 1.0)
			if f < (0.9 + (0.05 * musicLoops)):
				print("last loop, fading out")
				fade_music(-90, 0.0002)
				musicLimitLoop = musicLoops
				play_ambiance(ambiant_tracks[hour % ambiant_tracks.size()],0.0, 1, 0)
				musicLimitLoop
		elif musicLimitLoop:
			if not isFadingMusic:
				musicLimitLoop = false
				$MusicPlayer.stop()
				noMusicTicks = Utils.get_rng().randi_range(2, 12)
			
	pass

func stop_ambiance():
	isFadingAmbiance = true
	targetDB = -100

func stop_music():
	$MusicPlayer.stop()
