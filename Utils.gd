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

func get_collider(item):
	print("getting collider from ", item.itemName)
	for o in item.get_children():
		print(o, " - ", o.name, " - ")
		if o is CollisionShape:
			print(o, " is collision shape")
			return o
	return null

func get_inventory(controller):
	if(controller.has_method("get_inventory")):
		return controller.get_inventory()
	return null

static func get_world(node):
	return node.get_tree().get_root().get_node("World")

func interpolation(from, to, t):
	return from * (1 - t) + to * t

func instance_item(item):
	print("instancing ", item, ": controller: ", item.controller)
	var rig = load(item.prefabPath).instance()
	var undesirable = rig.get_node("Item")
	rig.remove_child(undesirable)
	undesirable.queue_free()
	rig.add_child(item)
#	var rig
#	if item.has_method("get_rigidbody"):
#		rig = item.get_rigidbody()
#	else:
#		rig = RigidBody.new()
#	print("rigidbody name: ", rig.name)
#	rig.add_child(item)
#	var c = get_collider(item)
#	print(c)
#	rig.add_child(c)
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
