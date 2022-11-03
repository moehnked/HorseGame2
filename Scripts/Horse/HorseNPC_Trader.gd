extends "res://Scripts/Horse/HorseNPC_Generic.gd"

var hasInitializedInventory:bool = false
export(Array, String) var initialInventories = ["generic1"]

# Called when the node enters the scene tree for the first time.
func get_inventory():
	if not hasInitializedInventory:
		#get_equipment_manager().inventory = InventoryParser.get_inventory_preset(initialInventories[Global.world.rng.randi_range(0, initialInventories.size() - 1)])
		var newInv = InventoryParser.get_inventory_preset(initialInventories[Global.world.rng.randi_range(0, initialInventories.size() - 1)])
		for i in newInv:
			i.add_self_to_inventory(get_equipment_manager(), true)
		hasInitializedInventory = true
	return get_equipment_manager().get_inventory()
