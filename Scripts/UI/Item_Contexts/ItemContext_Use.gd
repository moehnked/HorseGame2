extends TextureButton

var item
var controller

func initialize(args = {}):
	args = Utils.check(args, {"item":null, "controller":null})
	item = args.item
	controller = args.controller

func press_context():
	item.use_self()
	var tree = Global.world.get_tree()
	tree.call_group("InvScreen", "draw_list_items")
	tree.call_group("InvScreen", "draw_selected_icon")
	pass # Replace with function body.
