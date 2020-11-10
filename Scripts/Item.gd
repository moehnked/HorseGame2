extends Area

export var icon = "res://icon.png"
export var itemName = "Item"

var isInteractable = true
var mesh

func get_inventory(controller):
	if(controller.has_method("get_inventory")):
		return controller.get_inventory()
	return null

func interact(controller):
	#pick up the item and add it to player inventory
	if(get_inventory(controller) != null):
		controller.inventory.append(self.duplicate())
	queue_free()
	pass
	
func prompt():
	print("ITEM PROMPTOS")
	return "pick up"

func get_name():
	return itemName
