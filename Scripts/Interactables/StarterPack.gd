extends RigidBody

export(Dictionary) var items 
export(Resource) var effect

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func load_effect():
	Global.world.instance_resource(effect, global_transform.origin)

func open_pack():
	load_effect()
	for r in items.keys():
		for i in range(items[r]):
			var rng = Global.world.get_rng()
			var rx = rng.randf()
			var rz = rng.randf()
			var o = Global.world.instance_resource(r, global_transform.origin + Vector3(rx,0,rz))
			var dir = Vector3(rx, 2, rz).normalized()
			o.linear_velocity = dir * 5
	queue_free()


func _on_Interactable_interaction(controller):
	open_pack()
	pass # Replace with function body.
