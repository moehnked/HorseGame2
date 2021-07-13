extends Spatial

export(bool) var lookAt = true
export(float) var speed = 20



# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("FollowPlayer")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_transform.origin = global_transform.origin.linear_interpolate(Global.Player.global_transform.origin, speed * delta)
	if lookAt:
		global_transform = global_transform.looking_at(Global.Player.global_transform.origin, Vector3.UP)
	pass
