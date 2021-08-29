extends "res://Scripts/Items/Equipable.gd"


var lookingAt
var valid = false

func _process(delta):
	if isEquipped:
		toggle_collisions(false)
		lookingAt = controller.get_interaction_manager().lookingAt
		if lookingAt != null:
			#print(name, "  not looking at anything")
			if lookingAt.has_method("check_use_item") and lookingAt == controller.get_interaction_manager().get_raycast().get_collider():
				valid = lookingAt.call("check_use_item", self)
		pass
	else:
		#print(name, " not equipped")
		toggle_collisions(true)
		#set_sleeping(false)
		pass
	if input.standard and valid:
		print("Using ", get_name(), " on ", lookingAt.name)
		lookingAt.call("use_item", self)
	pass
