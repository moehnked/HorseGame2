extends Node

static func get_inventory_preset(key):
	var file = File.new()
	file.open("res://Data/TraderInventoryPresets.json", file.READ)
	var text = file.get_as_text()
	var dict = JSON.parse(text).result
	file.close()
	# print something from the dictionnary for testing.
	var inv = []
	for i in dict[key].keys():
		var obj = load(GlobalItemRepo.itemRefs[i]).instance()
		for j in range(dict[key][i]):
			inv.append(obj.duplicate(7))
	return inv
