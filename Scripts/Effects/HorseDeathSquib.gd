extends Spatial


export(Array, AudioStream) var sfx_blood
export(Array, AudioStream) var sfx_boom

var avaliable = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func initialize(point):
	$TTL.start()
	$Particles.emitting = true
	global_transform.origin = point
	play_sound($blood, Utils.get_random(sfx_blood))
	play_sound($boom, Utils.get_random(sfx_boom))
	avaliable = false
	pass

func play_sound(soundPlayer, sfx):
	soundPlayer.stream = sfx
	soundPlayer.play()


func _on_TTL_timeout():
	transform.origin = Vector3.ZERO
	avaliable = true
	pass # Replace with function body.
