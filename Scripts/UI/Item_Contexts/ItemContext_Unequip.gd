extends Control

var item
var controller


func is_unequip():
	return true

func initialize(args = {}):
	args = Utils.check(args, {"item":null, "controller":null})
	item = args.item
	controller = args.controller

func set_item(i):
	item = i

func unequip():
	#item.unequip(controller, self)
	print("unequip clicked ",item,", ",controller.equipped)
	item = controller.unequip({"caller":self})
	var tree = get_tree()
	tree.call_group("InvScreen", "draw_list_items")
	#tree.call_group("InvScreen", "draw_context")

func press_context():
	if controller.get_equipped() != null:
		if item.canUnequip:
			unequip()
		else:
			Global.world.get_tree().call_group("InvScreen", "play_error")
	pass # Replace with function body.
