extends Area

export(Dictionary) var desiredItems = {}
export(bool) var removeItemsOnUse = false
export(bool) var deleteSelfAfterUse = true
export(bool) var allowIterativePlacement = false
export(bool) var checkType = false

var lookingAtWithItem = false
var mostRecentController
var mostRecentItem
var mostRecentRaycast

signal item_use_complete(item)
signal looking_at_with_item(item)
signal unsuccessful_look_at(item)
signal notLookingAt()

func _process(delta):
	if mostRecentItem != null:
		#print("UseItemOn: mrc = ", mostRecentRaycast.name)
		if mostRecentRaycast.get_collider() != self:
			emit_signal("notLookingAt")
			mostRecentItem = null

func check_use_item(item):
	#print("checkingUseItem")
	mostRecentItem = item
	mostRecentController = mostRecentItem.controller.get_interaction_manager()
	mostRecentRaycast = mostRecentController.get_raycast()
	var count = 0
	for res in desiredItems.keys():
		var o = res
		if res is GDScript:
			if item is res:
				set_status(true, item)
				count += 1
			else:
				set_status(false, item)
		else:
			o = res.instance()
			if o.get_name() == item.get_name():
				set_status(true, item)
				count += 1
			else:
				set_status(false, item)
	return count == desiredItems.size()
	pass
	

func set_status(state, item):
	lookingAtWithItem = state
	emit_signal("looking_at_with_item" if state else "unsuccessful_look_at", item)

func use_item(item):
	var c = item.controller
	var i = item.controller.unequip()
	if removeItemsOnUse:
		Utils.remove_item(i, c.get_inventory())
	emit_signal("item_use_complete",item)
	if deleteSelfAfterUse:
		queue_free()
	pass

func recieve_looking_at(controller):
	#print(name, " has recieved_looking_at ", controller.name)
	pass
