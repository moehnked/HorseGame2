extends Node

static func calculate_adjusted_speed(stat):
	return 10 * sqrt(stat)

static func capture_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

static func check(args = {}, def = {}):
	var kargs = args
	for i in def.keys():
		if args.has(i):
			kargs[i] = args[i]
		else:
			kargs[i] = def[i]
	return kargs

static func contains(item, list):
	for i in list:
		if i.itemName == item.itemName:
			return true
	return false

static func count(item, list):
	var c = 0
	for i in list:
		if i.itemName == item.itemName:
			c += 1
	return c

func get_inventory(controller):
	if(controller.has_method("get_inventory")):
		return controller.get_inventory()
	return null

static func get_world(node):
	return node.get_tree().get_root().get_node("World")

func interpolation(from, to, t):
	return from * (1 - t) + to * t

func instance_item(item):
	var rig = RigidBody.new()
	rig.add_child(item)
	rig.add_child(item.get_collision_shape())
	return rig

static func logWithBase(value, base):
	return log(value) / log(base)

static func remove_item(item, list):
	var i = 0
	while(i < list.size()):
		if(list[i].itemName == item.itemName):
			list.remove(i)
			return
		i += 1

static func show_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
