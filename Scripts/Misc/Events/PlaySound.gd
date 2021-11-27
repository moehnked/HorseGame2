extends "res://Scripts/Misc/Events/GenericEvent.gd"

export(Resource) var sfx
export(Array, Resource) var random_sounds = []
export(float) var volume = 1.0

func _on_PlaySound_emit_event_triggered(by):
	if sfx != null:
		Global.AudioManager.play_sound(sfx.resource_path, volume)
	if random_sounds.size() > 0:
		Global.AudioManager.play_sound(random_sounds[Global.world.rng.randi() % random_sounds.size()])
	pass # Replace with function body.
