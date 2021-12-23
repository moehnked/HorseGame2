extends "res://Scripts/Misc/Events/GenericEvent.gd"

export(Resource) var sfx
export(Array, Resource) var random_sounds = []
export(float) var volume = 1.0
export(bool) var is3D = false

func play_sound(s):
	if is3D:
		Global.AudioManager.play_sound_3d(s, volume, global_transform.origin)
	else:
		Global.AudioManager.play_sound(s, volume)

func _on_PlaySound_emit_event_triggered(by):
	if sfx != null:
		#Global.AudioManager.play_sound(sfx.resource_path, volume)
		play_sound(sfx)
	if random_sounds.size() > 0:
		#Global.AudioManager.play_sound(random_sounds[Global.world.rng.randi() % random_sounds.size()])
		play_sound(Utils.get_random(random_sounds))
	pass # Replace with function body.
