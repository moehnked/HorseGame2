extends Spatial
export(int) var loadPriority = 0
export(Array, String) var deletedNodes = []

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("Persist")
	pass # Replace with function body.

func get_load_priority():
	return loadPriority

func record_node_delete(path):
	print(path)
	deletedNodes.append(path)

func save():
	return Utils.serialize_node(self)

func set(param, val):
	match param:
		"deletedNodes":
			deletedNodes = val
			for n in deletedNodes:
				var ob = get_node(n)
				if ob != null:
					remove_child(ob)
					ob.free()
					pass
		_:
			.set(param, val)

