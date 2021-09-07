extends "res://Scripts/Misc/Events/GenericEvent.gd"

export(Resource) var song
export(float) var volume = 1.0

func _on_PlaySound_emit_event_triggered(by):
	Global.AudioManager.play_song(song.resource_path, volume)
	pass # Replace with function body.
