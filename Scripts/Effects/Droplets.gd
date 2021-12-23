extends Spatial

func _ready():
	for c in get_children():
		c.disable()

func initialize(pos):
	global_transform.origin = pos + Vector3(0,0.2,0)
	for c in get_children():
		if Utils.get_rng().randi() % 2 == 0:
			c.initialize()
