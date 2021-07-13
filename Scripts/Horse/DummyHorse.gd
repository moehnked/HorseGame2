extends "res://Scripts/Horse/Horse.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_animation_controller():
	return null

func _on_Interactable_emit_prompt(_prompt):
	_prompt.prompt = "Dummy Horse"
	pass # Replace with function body.


func _on_Damageable_destroy():
	var soundPath = "res://Sounds/destroy_0" + String(Global.world.rng.randi_range(1,4)) + ".wav"
	Global.AudioManager.play_sound(soundPath)
	Global.world.instantiate("res://prefabs/Effects/deconstruct.tscn", global_transform.origin + Vector3(0,1,0))
	queue_free()
	pass # Replace with function body.
