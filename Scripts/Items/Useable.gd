extends "res://Scripts/Items/Equipable.gd"

export(bool) var consumeOnUse = true
export(bool) var useItemOnSelf = false

var canBeUsed = true
var lookingAt
var prevLookingAt
var valid = false

signal emit_item_used(item)

func consume():
	if lookingAt != null:
		if lookingAt.has_method("unhighlight"):
			lookingAt.call("unhighlight")
	if controller != null:
		var c = controller
		if isEquipped:
			controller.unequip({"returnToInventory": false})
		Utils.remove_item(self , controller.get_inventory())
	queue_free()

func parse_lookingat():
	if lookingAt != prevLookingAt and prevLookingAt != null:
			if prevLookingAt.has_method("unhighlight"):
				prevLookingAt.call("unhighlight")
	if lookingAt != null:
		if lookingAt.has_method("check_use_item"):
			return lookingAt
		else:
			var p = lookingAt.get_parent()
			if p != null:
				if p.has_method("check_use_item"):
					return p
	return null

func use_self():
	emit_signal("emit_item_used", self)
	if consumeOnUse:
		consume()

func _process(delta):
	if isEquipped and get_controller() != null:
		canBeUsed = true
		#toggle_collisions(false)
		lookingAt = get_controller().get_interaction_manager().lookingAt
		lookingAt = parse_lookingat()
		if lookingAt != null:
			valid = lookingAt.check_use_item(self)
		else:
			valid = false
			lookingAt = null
		if (input.standard or input.special) and valid:
			print("Using ", get_name(), " on ", lookingAt.name)
			lookingAt.call("use_item", self)
			canBeUsed = false
		if useItemOnSelf and canBeUsed and (input.standard or input.special):
			use_self()
		prevLookingAt = lookingAt
	else:
		#print(name, " not equipped")
		#toggle_collisions(canBeUsed)
		#set_sleeping(not canBeUsed)
		pass
	._process(delta)
	pass
#
#func _process(delta):
#	if isEquipped and get_controller() != null:
#		canBeUsed = true
#		#toggle_collisions(false)
#		lookingAt = get_controller().get_interaction_manager().lookingAt
#		if lookingAt != null:
#			if lookingAt != prevLookingAt and prevLookingAt != null:
#				if prevLookingAt.has_method("unhighlight"):
#					prevLookingAt.call("unhighlight")
#			print(get_name(), " looking at anything ", lookingAt.name)
#			if lookingAt.has_method("check_use_item") and lookingAt == get_controller().get_interaction_manager().get_raycast().get_collider():
#				valid = lookingAt.call("check_use_item", self)
#			else:
#				valid = false
#				lookingAt = null
#			if (input.standard or input.special) and valid:
#				print("Using ", get_name(), " on ", lookingAt.name)
#				lookingAt.call("use_item", self)
#				canBeUsed = false
#		if useItemOnSelf and canBeUsed and (input.standard or input.special):
#			use_self()
#		prevLookingAt = lookingAt
#	else:
#		#print(name, " not equipped")
#		#toggle_collisions(canBeUsed)
#		#set_sleeping(not canBeUsed)
#		pass
#	._process(delta)
#	pass
