extends Spatial

var count = 0
var fadeout = false
export(int) var limit = 0
export(float) var spawnRange = 10
export(Resource) var spawnResource
export(float) var time = 4.0


# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start(time)
	pass # Replace with function body.

func start_fade_out(ttl = 25):
	fadeout = true
	$KillTimer.start(ttl)

func spawn():
	var r = Global.world.rng.randf_range(-spawnRange, spawnRange)
	Global.world.place(spawnResource.instance(), global_transform.origin + Vector3(r,r,r))

func _on_Timer_timeout():
	if fadeout:
		time += 1
	if count < limit or limit <= 0:
		spawn()
		$Timer.start(time)
		count += 1
	else:
		queue_free()
	pass # Replace with function body.
