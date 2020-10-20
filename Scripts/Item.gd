extends Area

var mesh
export var icon = "res://icon.png"
export var itemName = "Item" 

func interact(controller):
	#pick up the item and add it to player inventory
	controller.inventory.append(self.duplicate())
	queue_free()
	pass
	
func prompt():
	print("ITEM PROMPTOS")
	return "pick up"

func get_name():
	return itemName
