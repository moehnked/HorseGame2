extends Spatial

export(Vector3) var angle = Vector3(1,1,1)
export(float) var weight = 0.5


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation_degrees = lerp(rotation_degrees, rotation_degrees + angle, weight)
	pass
