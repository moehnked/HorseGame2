extends Node

static func angle_to(from, to):
	return atan2(to.y - from.y, to.x - from.x) * 180 / PI;

static func between(val, mi, ma):
	return (val > mi and val < ma)

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
	if item is String:
		for i in list:
			if i.get_name() == item:
				return true
		return false
	else:
		for i in list:
			if i.get_name() == item.get_name():
				return true
		return false

static func count(item, list):
	var c = 0
	for i in list:
		if i.get_name() == item.get_name():
			c += 1
	return c

static func custom_function_env_light(x):
	var y = x
	y = x * 0.0345
	y = y - 1.5
	y = sin(y)
	y = y / 2
	y = y + 0.5
	return y
	

func get_all_items_by_name(list, itemname):
	var a = []
	for i in list:
		if i.get_name() == itemname:
			a.append(i)
	return a

func get_collider(item):
	print("getting collider from ", item.itemName)
	for o in item.get_children():
		if o is CollisionShape:
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

func uPrint(message, caller):
	print(caller.get_name(),": " + message)

func instance_item(item):
	print("instancing ", item, ": controller: ", item.controller)
	Global.world.call_deferred("add_child", item)
	return item
#	var rig = load(item.prefabPath).instance()
#	var undesirable = rig.get_node("Item")
#	rig.remove_child(undesirable)
#	undesirable.queue_free()
#	rig.add_child(item)
#	return rig

static func logWithBase(value, base):
	return log(value) / log(base)

static func play_sound(player, sound_path = "", volume = 0.0):
	player.stream = load(sound_path)
	if player is AudioStreamPlayer:
		player.volume_db = volume
	else:
		player.unit_db = volume
	player.play()

static func pop_item_by_name(itemName, list):
	var i = 0
	while(i < list.size()):
		if(list[i].get_name() == itemName):
			var tmp = list[i]
			list.remove(i)
			return tmp
		i += 1

static func pop_item(item, list):
	var i = list.find(item)
	var tmp = list[i]
	list.remove(i)
	return tmp

static func remove_item(item, list):
	var i = 0
	while(i < list.size()):
		if(list[i].itemName == item.itemName):
			list.remove(i)
			return
		i += 1

static func show_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
