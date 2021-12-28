extends Spatial

var hat = null

func _process(delta):
	if hat != null:
		print(hat)
		#hat.global_transform.origin = global_transform.origin
		hat.global_transform = global_transform

func add_hat(item):
	print("hat added!")
	add_child(item)
	hat = item
	hat.toggle_collisions(false)
	hat.connect("emit_equipped", self, "remove_hat")

func remove_hat(item):
	hat = null
