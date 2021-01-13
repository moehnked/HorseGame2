extends Node



# Called when the node enters the scene tree for the first time.
func _ready():
	Global.SEM = self
	pass # Replace with function body.
	

func play_random_bit():
	$BitPlayDelay.start(1.5)
	pass

func play_bit(path, db = 0.0):
	$AudioStreamPlayer.stream = load(path)
	$AudioStreamPlayer.volume_db = db
	$AudioStreamPlayer.play()


func _on_BitPlayDelay_timeout():
	if not $AudioStreamPlayer.playing:
		play_bit("res://Music/Bits/bits_0"+ String(Global.world.rng.randi_range(1,3)) +".wav")
	pass # Replace with function body.
