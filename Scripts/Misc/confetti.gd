extends Spatial

func _ready():
	$Timer.start()
	$Particles.emitting = true
	$Particles2.emitting = true
	$Particles3.emitting = true
	$Particles4.emitting = true
	print("I'm alive")
	$AudioStreamPlayer3D.play()
	pass

func _on_Timer_timeout():
	queue_free()
	pass # Replace with function body.
