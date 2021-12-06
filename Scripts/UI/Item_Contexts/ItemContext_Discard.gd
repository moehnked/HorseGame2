extends TextureButton

var item
var controller

func initialize(args = {}):
	args = Utils.check(args, {"item":null, "controller":null})
	item = args.item
	controller = args.controller


func discard():
	if controller.equipped == item:
		controller.unequip({"returnToInventory":false})
	var p = controller.get_parent()
	var h = p.get_head()
	var point = h.global_transform.origin - (h.global_transform.basis.z * 1.5)
	Utils.instance_item(item).global_transform.origin = point
	Utils.remove_item(item , controller.get_inventory())
	#controller.get_inventory().erase(item)
	var tree = Global.world.get_tree()
	tree.call_group("InvScreen", "draw_list_items")
	tree.call_group("InvScreen", "draw_selected_icon")
	#print("calling clear context from discard button")
	#tree.call_group("InvScreen", "clear_context")
	#print("end of discard")
	pass


func _on_Discard_focus_entered():
	print("Discard: gained focus")
	pass # Replace with function body.


func _on_Discard_focus_exited():
	print("Discard: release focus")
	pass # Replace with function body.
