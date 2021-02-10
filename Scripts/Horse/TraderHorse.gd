extends "res://Scripts/Horse/Horse.gd"

var hasInitializedInventory:bool = false

# Called when the node enters the scene tree for the first time.
func get_inventory():
	if not hasInitializedInventory:
		get_equipment_manager().inventory = InventoryParser.get_inventory_preset("generic1")
		hasInitializedInventory = true
	return get_equipment_manager().get_inventory()

