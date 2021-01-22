extends Control

var item
var controller

func is_unequip():
	return true

func initialize(args = {}):
	args = Utils.check(args, {"item":load("res://prefabs/Items/Equipable.tscn").instance(), "controller":null})
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
	tree.call_group("InvScreen", "draw_context", item)

func _on_TextureButton_button_up():
	unequip()
	pass # Replace with function body.
