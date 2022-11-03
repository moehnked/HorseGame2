extends Node2D

signal emit_failure()
signal emit_success()

export(Array, NodePath) var noteSpawns
export(Array, NodePath) var buttons
export(Array, AudioStream) var sfxReel
export(Array, AudioStream) var sfxMissed
export(Array, AudioStream) var sfxFish
export(Array, AudioStream) var sfxSuccess
export(Curve) var rodTimeScale


var fishLevel = 10
var noteRef = preload("res://prefabs/UI/Misc/FishHero_fishNote.tscn")
var percRemain = 1.0
var rodPower = 5
var reelRot = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	#$NoteSpawnTimer.wait_time = 1
	Physics2DServer.set_active(true)
	$loop.play()
	$NoteSpawnTimer.start(get_spawn_time())
	for btn in buttons:
		var b = get_node(btn)
		b.connect("successful_hit", self, "successful_hit")
		b.connect("missed_hit", self, "missed_hit")
		b.connect("emit_pressed", self, "update_fish_cursor")
	pass # Replace with function body.

func _process(delta):
	#rect_position = rect_position.linear_interpolate(Vector2(0,0), 0.5)
	position = position.linear_interpolate(Vector2(0,0), 0.5)
	$reel/reel_handle.rotation_degrees = lerp($reel/reel_handle.rotation_degrees, reelRot, 0.5)
	update_time_remaining()
	$TimeRemaining.rect_scale.y = lerp($TimeRemaining.rect_scale.y, percRemain, 0.2)
	if $FishOMeterRim/Fish_O_Meter.rotation_degrees < -165:
		emit_signal("emit_failure")
	pass

func get_spawn_time():
	return 1.1 - (0.06 * fishLevel)

func initialize(_fishLevel, _rodPower):
	fishLevel = _fishLevel
	rodPower = _rodPower

func successful_hit():
	$FishOMeterRim/Fish_O_Meter.rotation_degrees = min($FishOMeterRim/Fish_O_Meter.rotation_degrees + (15 - fishLevel), 0)
	$ReelSounds.stream = Utils.get_random(sfxReel)
	$ReelSounds.play()
	$loop.volume_db = -5
	$SuccessSounds.stream = Utils.get_random(sfxSuccess)
	$SuccessSounds.play()
	reelRot += 33

func missed_hit():
	$FishOMeterRim/Fish_O_Meter.rotation_degrees = max($FishOMeterRim/Fish_O_Meter.rotation_degrees - (40 - rodPower), -170)
	#rect_position = Vector2(Utils.rand_float_range(-20,20), Utils.rand_float_range(-20,20))
	position = Vector2(Utils.rand_float_range(-20,20), Utils.rand_float_range(-20,20))
	$MissedSounds.stream = Utils.get_random(sfxMissed)
	$MissedSounds.play()
	$loop.volume_db = -80

func update_fish_cursor(pos):
	$fishCursor.position.x = pos.x
	$fishCursor.randomize_sprite()
	$fishCursor/AnimationPlayer.play("default")
	$FishSounds.stream = Utils.get_random(sfxFish)
	$FishSounds.play()

func update_time_remaining():
	percRemain -=  rodTimeScale.interpolate(float(rodPower) * 0.1)
	if percRemain < 0.01:
		emit_signal("emit_success")


func _on_NoteSpawnTimer_timeout():
	var spawn = get_node(Utils.get_random(noteSpawns))
	var n = noteRef.instance()
	$TrackSpawns.add_child(n)
	n.position = spawn.position
	n.set_speed(fishLevel)
	$NoteSpawnTimer.start(get_spawn_time())
	pass # Replace with function body.


func _on_NoteMissed_missed_note():
	missed_hit()
	pass # Replace with function body.
