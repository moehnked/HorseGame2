extends "res://Scripts/Interactable.gd"

export var deleteOnInteract:bool = true
export var icon = "res://icon.png"
export var itemName = "Item"
export var prefabPath = "res://prefabs/Items/Item.tscn"


#var isInteractable = true

func get_collision_shape():
	for i in get_children():
		if i is CollisionObject:
			return i
	return CollisionObject.new()

func get_context():
	return get_node("Context")

func get_icon(asTexture = false):
	return load(icon) if asTexture else icon

func interact(controller):
	.interact(controller)
	if deleteOnInteract:
		queue_free()
	pass

func prompt():
	return "pick up"

func get_name():
	return itemName
