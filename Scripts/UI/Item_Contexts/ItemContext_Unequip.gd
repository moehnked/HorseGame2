extends Control

var item
var controller

func initialize(args = {}):
	args = Utils.check(args, {"item":load("res://prefabs/Items/Equipable.tscn").instance(), "controller":null})
	item = args.item
	controller = args.controller

func set_item(i):
	item = i

func _on_TextureButton_button_up():
	item.unequip(controller, self)
	var tree = get_tree()
	tree.call_group("InvScreen", "draw_list_items")
	tree.call_group("InvScreen", "draw_context", item)
	
	pass # Replace with function body.
