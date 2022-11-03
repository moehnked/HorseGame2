extends "res://Scripts/Misc/Events/GenericEvent.gd"

export(bool) var deferred = true
export(bool) var is3D = false
export(Array, Resource) var random_sounds = []
export(Resource) var sfx
export(float) var volume = 1.0

var queuedSFX

func get_queue():
	return queuedSFX

func play_sound(s):
	if is3D:
		Global.AudioManager.play_sound_3d(s, volume, global_transform.origin)
	else:
		Global.AudioManager.play_sound(s, volume)

func queue_sound(s):
	queuedSFX = s
	if deferred:
		add_to_group("AudioQueue")
	else:
		play_sound(s)

func _on_PlaySound_emit_event_triggered(by):
	if sfx != null:
		#Global.AudioManager.play_sound(sfx.resource_path, volume)
		#play_sound(sfx)
		queue_sound(sfx)
	if random_sounds.size() > 0:
		#Global.AudioManager.play_sound(random_sounds[Global.world.rng.randi() % random_sounds.size()])
		#play_sound(Utils.get_random(random_sounds))
		queue_sound(Utils.get_random(random_sounds))
	pass # Replace with function body.
