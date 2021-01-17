extends "res://Scripts/NewItems/Equipable.gd"

export var power:int = 20
export var throwSoundPath = ""

func _process(delta):
	if input.standard and isEquipped:
		throw()

func throw():
	var tmp = unequipSoundPath
	var tmpcontr = controller
	unequipSoundPath = throwSoundPath
	linear_velocity = -controller.get_parent().get_head().global_transform.basis.z * power
	controller.unequip(false)
	if Utils.contains(self, tmpcontr.get_inventory()):
		var i = Utils.pop_item_by_name(self.get_name(), tmpcontr.get_inventory())
		Utils.instance_item(i).interact(tmpcontr)
	unequipSoundPath = tmp
	pass
