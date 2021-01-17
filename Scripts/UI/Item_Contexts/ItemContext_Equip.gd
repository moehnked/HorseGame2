extends Control

var item
var controller

func is_equip():
	return true

func initialize(args = {}):
	args = Utils.check(args, {"item":load("res://prefabs/Items/Equipable.tscn").instance(), "controller":null})
	item = args.item
	controller = args.controller

func equip():
	print("equipping ", item," to ", controller)
	Global.world.call_deferred("add_child", item)
	item.interact(controller)
	var tree = get_tree()
	tree.call_group("InvScreen", "draw_list_items")
	tree.call_group("InvScreen", "draw_context", item)

func _on_TextureButton_button_up():
	if controller.equipped != item:
		equip()
	pass # Replace with function body.
