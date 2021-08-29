extends Area

export(Dictionary) var desiredItems = {}
export(bool) var removeItemsOnUse = false
export(bool) var deleteSelfAfterUse = true
export(bool) var allowIterativePlacement = false

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
	mostRecentItem = item
	mostRecentController = mostRecentItem.controller.get_interaction_manager()
	mostRecentRaycast = mostRecentController.get_raycast()
	var count = 0
	for res in desiredItems.keys():
		var o = res.instance()
		if o.get_name() == item.get_name():
			lookingAtWithItem = true
			emit_signal("looking_at_with_item", item)
			count += 1
		else:
			lookingAtWithItem = false
			emit_signal("unsuccessful_look_at", item)
	return count == desiredItems.size()
	pass
	

func use_item(item):
	var c = item.controller
	var i = item.controller.unequip()
	if removeItemsOnUse:
		Utils.remove_item(i, c.get_inventory())
	emit_signal("item_use_complete",item)
	if deleteSelfAfterUse:
		queue_free()
	pass
