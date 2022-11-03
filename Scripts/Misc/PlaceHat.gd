extends Spatial

var hat = null

func _process(delta):
	if hat != null:
		hat.global_transform = global_transform

func add_hat(item):
	print("hat added!")
	add_child(item)
	hat = item
	hat.toggle_collisions(false)
	hat.connect("emit_equipped", self, "remove_hat")
	if item.has_method("set_rack"):
		item.call("set_rack", self)

func remove_hat(item):
	hat = null
	item.call("set_rack", null)
