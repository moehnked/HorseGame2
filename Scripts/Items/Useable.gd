extends "res://Scripts/Items/Equipable.gd"


var lookingAt
var valid = false
var canBeUsed = true

func _process(delta):
	if isEquipped:
		canBeUsed = true
		toggle_collisions(false)
		lookingAt = controller.get_interaction_manager().lookingAt
		if lookingAt != null:
			#print(get_name(), " looking at anything ", lookingAt.name)
			if lookingAt.has_method("check_use_item") and lookingAt == controller.get_interaction_manager().get_raycast().get_collider():
				valid = lookingAt.call("check_use_item", self)
			else:
				valid = false
				lookingAt = null
			if (input.standard or input.special) and valid:
				print("Using ", get_name(), " on ", lookingAt.name)
				lookingAt.call("use_item", self)
				canBeUsed = false
	else:
		#print(name, " not equipped")
		toggle_collisions(canBeUsed)
		#set_sleeping(false)
		pass
	pass
