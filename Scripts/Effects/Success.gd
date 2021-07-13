extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.AudioManager.play_sound("res://Sounds/Special_" + String(Global.world.rng.randi_range(1,5)) + ".wav")
	$Particles2D.emitting = true
	pass # Replace with function body.


func _on_TTL_timeout():
	queue_free()
	pass # Replace with function body.
