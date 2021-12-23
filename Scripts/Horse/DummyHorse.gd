extends "res://Scripts/Horse/Horse.gd"


func initialize_breed():
	print("dummy horse has no breed")

func get_animation_controller():
	return null

func _on_Interactable_emit_prompt(_prompt):
	_prompt.prompt = "Dummy Horse"
	pass # Replace with function body.


func _on_Damageable_destroy():
	var soundPath = "res://Sounds/destroy_0" + String(Global.world.rng.randi_range(1,4)) + ".wav"
	Global.AudioManager.play_sound(soundPath)
	Global.world.instantiate("res://prefabs/Effects/deconstruct.tscn", global_transform.origin + Vector3(0,1,0))
	get_tree().call_group("on_destroy_event","trigger", self)
	queue_free()
	pass # Replace with function body.

func tame(args):
	.tame(args)
	if trainer != null:
		trainer.remove_from_party(self)
	pass
