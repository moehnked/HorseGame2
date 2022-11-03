extends Node2D

export(float) var angle = 1.0
export(float) var weight = 0.5


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation_degrees = lerp(rotation_degrees, rotation_degrees + angle, weight)
	pass
