extends "res://Scripts/Misc/Events/GenericEvent.gd"


func _on_KillGhostHorseSpawner_emit_event_triggered(by):
	Global.world.get_tree().call_group("FollowPlayer", "queue_free")
	by.queue_free()
	queue_free()
	pass # Replace with function body.
