extends Node


static func align_up(node_basis, normal):
	var result = Basis()
	var scale = node_basis.get_scale() # Only if your node might have a scale other than (1,1,1)

	result.x = normal.cross(node_basis.z)
	result.y = normal
	result.z = node_basis.x.cross(normal)

	result = result.orthonormalized()
	result.x *= scale.x 
	result.y *= scale.y 
	result.z *= scale.z 

	return result

static func angle_to(from, to):
	return atan2(to.y - from.y, to.x - from.x) * 180 / PI;

static func between(val, mi, ma):
	return (val > mi and val < ma)

static func calculate_adjusted_speed(stat):
	return 10 * sqrt(stat)

static func capture_mouse():
	print("Utils: capturing mouse")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

static func check(args = {}, def = {}):
	var kargs = args
	for i in def.keys():
		if args.has(i):
			kargs[i] = args[i]
		else:
			kargs[i] = def[i]
	return kargs

static func check_dist(from, to, thresh):
	return from.global_transform.origin.distance_to(to.global_transform.origin) > thresh

static func check_options_contains(res, ops):
	for i in ops:
		print(i.resPath)
		if i.resPath == res.resource_path:
			return true
	return false

static func compare_floats(a, b, epsilon = 0.02):
	return abs(a - b) <= epsilon

static func contains(item, list):
	if item is String:
		for i in list:
			if i.get_name() == item:
				return true
		return false
	else:
		for i in list:
			if i != null:
				if i.get_name() == item.get_name():
					return true
		return false

static func count(item, list):
	var c = 0
	if item is String:
		item = get_item_by_name(item, list)
	if item != null:
		for i in list:
			if i != null:
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

static func freeze_rigidbody(r, st = true):
	r.set_axis_lock ( 1, st )
	r.set_axis_lock ( 2, st )
	r.set_axis_lock ( 4, st )
	

static func get_item_by_name(itemName, list):
	for i in list:
		if i.get_name() == itemName:
			return i
	return null

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

static func get_random(list):
	return list[Global.world.rng.randi() % list.size()]

static func get_rng():
	return Global.world.rng

static func get_world(node):
	return node.get_tree().get_root().get_node("World")

func interpolation(from, to, t):
	return from * (1 - t) + to * t

func uPrint(message, caller):
	print(caller.get_name(),": " + message)

func instance_item(item):
	print("instancing ", item, ": controller: ", item.controller)
	Global.world.call("add_child", item)
	return item

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
		if list[i] == null:
			return null
		if(list[i].get_name() == itemName):
			return pop_item(list[i], list)
		i += 1

static func pop_item(item, list):
	var i = list.find(item)
	var tmp = list[i]
	if tmp != null:
		if "isEquipped" in tmp:
			if tmp.isEquipped:
				tmp.controller.unequip()
	list.remove(i)
	return tmp

static func remove_item(item, list):
	for i in list:
		if i != null:
			if i.get_name() == item.get_name():
				list.erase(i)
				return
static func rand_float_range(from = 0.0, to = 1.0):
	return get_rng().randf_range(from, to)
	
static func reparent(child: Node, new_parent: Node):
	var old_parent = child.get_parent()
	#if old_parent == null:
	#	old_parent = child.owner
	if old_parent != null:
		old_parent.remove_child(child)
	new_parent.add_child(child)

static func show_mouse(custom = false, res = "res://Sprites/misc/publicdomainPack/cursor.png"):
	#print("Utils: showing mouse")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if custom:
		Input.set_custom_mouse_cursor(load(res))

static func uniques(list):
	var u = []
	for i in list:
		if i != null:
			if u.size() == 0:
				u.append(i)
			elif !contains(i,u):
				u.append(i)
	return u

static func wrap(x, a, b):
	if x < a:
		return x + abs(b - a)
	elif x > b:
		return x - abs(b - a)
	else:
		return x
	pass
