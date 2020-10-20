extends Spatial

func _ready():
	$Particles.emitting = true
	$Particles2.emitting = true
	$AnimationPlayer.play("fadeout")

func _on_Timer_timeout():
	queue_free()
	pass # Replace with function body.
