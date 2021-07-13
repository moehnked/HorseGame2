extends Spatial

export var pathSpeed = 0.001

# Called when the node enters the scene tree for the first time.
func _ready():
	$Path/PathFollow/horse_animated.set_playback_speed(Global.world.rng.randf_range(0.5, 2.5))
	$Path/PathFollow/horse_animated.play_animation("Trot")
	pathSpeed = Global.world.rng.randf_range(0.001, 0.005)
	global_transform = global_transform.looking_at(Global.Player.global_transform.origin, Vector3.UP)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Path/PathFollow.unit_offset += pathSpeed
	#$Path/PathFollow/horse_animated.transform = $Path/PathFollow/horse_animated.transform.looking_at($Path/PathFollow.transform.origin, Vector3.UP)
	if $Path/PathFollow.unit_offset >= 0.99:
		queue_free()
	pass
