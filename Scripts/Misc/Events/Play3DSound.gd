extends "res://Scripts/Misc/Events/GenericEvent.gd"

export(String) var soundPath
export(float) var db
export(float) var size

func _on_Play3DSound_emit_event_triggered(by):
	Global.AudioManager.play_sound_3d(soundPath, db, global_transform.origin, size)
	pass # Replace with function body.
