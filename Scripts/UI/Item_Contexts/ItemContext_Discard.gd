extends Control

var item
var controller

func initialize(args = {}):
	args = Utils.check(args, {"item":load("res://prefabs/Items/Equipable.tscn").instance(), "controller":null})
	item = args.item
	controller = args.controller


func discard():
	if controller.equipped == item:
		controller.unequip({"returnToInventory":false})
	var p = controller.get_parent()
	var h = p.get_head()
	var point = h.global_transform.origin - (h.global_transform.basis.z * 1.5)
	Utils.instance_item(item).global_transform.origin = point
	controller.get_inventory().erase(item)
	pass

func _on_TextureButton_button_up():
	discard()
	var tree = get_tree()
	tree.call_group("InvScreen", "draw_list_items")
	tree.call_group("InvScreen", "draw_context", null)
	pass # Replace with function body.
