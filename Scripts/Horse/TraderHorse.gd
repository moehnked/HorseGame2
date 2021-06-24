extends "res://Scripts/Horse/Horse.gd"

var hasInitializedInventory:bool = false
export(Array, String) var initialInventories = ["generic1"]

# Called when the node enters the scene tree for the first time.
func get_inventory():
	if not hasInitializedInventory:
		get_equipment_manager().inventory = InventoryParser.get_inventory_preset(initialInventories[Global.world.rng.randi_range(0, initialInventories.size() - 1)])
		hasInitializedInventory = true
	return get_equipment_manager().get_inventory()

