extends "res://prefabs/Misc/Events/Rotate.gd"


func _on_HorsePillar1_rotation_complete():
	print(name, " finished roation")
	Global.world.get_tree().call_group("HorseRelief", "trigger", self)
	isRotating = false
	pass # Replace with function body.


func _on_HorsePillar1_emit_event_triggered(by):
	Global.AudioManager.play_sound_3d("res://Sounds/rock_01.wav", 5, global_transform.origin, 20)
	pass # Replace with function body.
