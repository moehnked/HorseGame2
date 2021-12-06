extends TextureButton

var item
var controller


func is_equip():
	return true

func initialize(args = {}):
	args = Utils.check(args, {"item":null, "controller":null})
	item = args.item
	controller = args.controller

func equip():
	print("equipping ", item," to ", controller)
	if controller.get_equipped() != null:
		controller.unequip()
	Global.world.call_deferred("add_child", item)
	item.interact(controller)
	var tree = get_tree()
	tree.call_group("InvScreen", "draw_list_items")
#	tree.call_group("InvScreen", "draw_list_items")
#	tree.call_group("InvScreen", "draw_context", item)

func press_context():
	if controller.equipped != item:
		equip()
	pass # Replace with function body.
