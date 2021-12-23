extends TextureButton

var item
var controller

func initialize(args = {}):
	args = Utils.check(args, {"item":null, "controller":null})
	item = args.item
	controller = args.controller

func check_discard():
	if item.has_method("unequip"):
		return item.canUnequip
	else:
		return true

func discard():
	if check_discard():
		if controller.equipped == item:
			controller.unequip({"returnToInventory":true})
		var p = controller.get_parent()
		var h = p.get_head()
		var point = h.global_transform.origin - (h.global_transform.basis.z * 1.5)
		var pointb = Vector3(0,0,0)
		if controller.get_parent().has_method("get_solid_raycast"):
			var r = controller.get_parent().get_solid_raycast()
			if r.is_colliding():
				pointb = r.get_collision_point()
				if h.global_transform.origin.distance_to(point) > h.global_transform.origin.distance_to(pointb):
					point = h.global_transform.origin + Vector3(0,4,0)

		Utils.instance_item(item).global_transform.origin = point
		Utils.remove_item(item , controller.get_inventory())
		var tree = Global.world.get_tree()
		tree.call_group("InvScreen", "draw_list_items")
		tree.call_group("InvScreen", "draw_selected_icon")
	else:
		Global.world.get_tree().call_group("InvScreen", "play_error")
	pass
