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

static func flat_angle_vec3(from, to):
	var a = Vector2(from.x, from.y)
	var b = Vector2(to.x, to.y)
	return a.angle_to_point(b)

static func basis_to_ar(basis):
	return [basis.x.x,basis.x.y,basis.x.z,
	basis.y.x,basis.y.y,basis.y.z,
	basis.z.x,basis.z.y,basis.z.z]

static func basis_from_ar(ar):
	var x = Vector3(ar[0],ar[1],ar[2])
	var y = Vector3(ar[3],ar[4],ar[5])
	var z = Vector3(ar[6],ar[7],ar[8])
	return Basis(x,y,z)

static func basis_from_string(from):
	from = from.strip("()")
	print(from)

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

static func contains_unique(item, list):
	var iop = item.get_original_path()
	for i in list:
		var comp = i.get_original_path()
		if iop == comp:
			return true
	return false
	pass

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

static func create_spatial_at(point):
	var obj = load("res://prefabs/Misc/EmptySpatial.tscn").instance()
	return obj

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

static func get_global_position(node):
	return node.global_transform.origin

static func get_inventory(controller):
	if(controller.has_method("get_inventory")):
		return controller.get_inventory()
	return null

static func get_original_path(node):
	if node.has_method("get_original_path"):
		return node.call("get_original_path")
	else:
		return node.get_path()

static func get_parent_original_path(node):
	if node.has_method("get_parent_original_path"):
		return node.call("get_parent_original_path")
	else:
		return node.get_parent().get_path()

static func get_random(list):
	return list[(Global.world.rng.randi() if Global.world != null else randi()) % list.size()]

static func get_rng():
	return Global.world.rng if Global.world != null else RandomNumberGenerator.new()

static func get_world(node):
	return node.get_tree().get_root().get_node("World")

func interpolation(from, to, t):
	return from * (1 - t) + to * t

static func int2enum(i, enu):
	var vals = enu.values()
	for k in enu.keys():
		if enu[k] == i:
			return enu[k]
	return -1

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
				i.controller = null
				return

static func rand_float_range(from = 0.0, to = 1.0):
	return get_rng().randf_range(from, to)
	
static func reparent(child: Node, new_parent: Node):
	if new_parent != child.get_parent():
		var pos = null
		if child is Spatial:
			pos = child.global_transform.origin
		var old_owner = child.owner
		if old_owner != null:
			if old_owner.has_method("record_node_delete"):
				old_owner.call("record_node_delete", child.get_path())
		var old_parent = child.get_parent()
		#if old_parent == null:
		#	old_parent = child.owner
		if old_parent != null:
			if old_parent.has_method("record_node_delete") and old_parent != old_owner:
				old_parent.call("record_node_delete", child.get_path())
			old_parent.remove_child(child)
		new_parent.add_child(child)
		if pos != null:
			child.global_transform.origin = pos

static func report_node_deletion(node):
	var own = node.owner
	if own != null:
		if own.has_method("record_node_delete"):
			own.call("record_node_delete", node.get_path())
	var par = node.get_parent()
	if par != null:
		if par.has_method("record_node_delete"):
			par.call("record_node_delete", node.get_path())

static func reverse(array):
	var ar = []
	for i in array:
		ar.push_front(i)
	return ar

static func save_items_from_list(list, equipped):
	for n in list:
		if n != equipped:
			Global.world.add_to_save_queue(n)

static func serialize_node(node, overrides = {}):
	var save_dict = inst2dict(node)
	for p in save_dict.keys():
		if p in node:
			if node[p] is Resource:
				save_dict[p] = node[p].resource_path
			elif node[p] is Array:
				var resar = node[p]
				if resar.size() > 0:
					if resar[0] is Resource:
						save_dict[p] = []
						for r in resar:
							save_dict[p].append(r.resource_path)
	save_dict["nodegroups"] = node.get_groups()
	save_dict["filename"] = node.get_filename()
	save_dict["parent"] = get_parent_original_path(node)
	save_dict["nodeName"] = node.name
	save_dict["nodePath"] = get_original_path(node)
	save_dict["isInTree"] = node.is_inside_tree()
	save_dict["oldOwner"] = node.owner.get_path() if node.owner != null else Global.world.get_path()
	save_dict["instID"] = node.get_instance_id()
	if node is Spatial:
		var pos = get_global_position(node)
		save_dict['posx'] = pos.x
		save_dict['posy'] = pos.y
		save_dict['posz'] = pos.z
		save_dict['basis'] = basis_to_ar(node.global_transform.basis)
	return Utils.check(overrides, save_dict)

static func set_prop(node, param, val):
	if param == "nodegroups":
		for g in val:
			node.add_to_group(g)
	else:
		if param in node:
			if node[param] is Resource:
				val = load(val)
			if val is Array:
				if val.size() > 0:
					if val[0] is String:
						var restr = "res://"
						var s = val[0].left(6)
						if s == restr:
							var ar = []
							for i in val:
								ar.append(load(i))
							val = ar
		node.set(param, val)

static func show_mouse(custom = false, res = "res://Sprites/misc/publicdomainPack/cursor.png", forceMouseShow = false):
	#print("Utils: showing mouse")
	if !Global.InputObserver.isJoypadMode or forceMouseShow:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		if custom:
			Input.set_custom_mouse_cursor(load(res))

static func string2color(s):
	print(s)
	var vec = s.split(",", true, 3)
	return Color(float(vec[0]), float(vec[1]), float(vec[2]), float(vec[3]))

static func string2vec(s:String):
	s = s.right(1)
	s = s.left(s.length() - 1)
	print(s)
	var vec = s.split(",", true, 2)
	return Vector3(float(vec[0]), float(vec[1]), float(vec[2]))

static func transform_mouse(pos):
	if OS.window_fullscreen:
		pos = pos * (Vector2(1024,600)/ OS.get_screen_size())
	return pos

static func uniques(list):
	var u = []
	for i in list:
		if i != null:
			if u.size() == 0:
				u.append(i)
			elif !contains(i,u):
				u.append(i)
	return u

func vol2db(vol):
	return 10 * log(vol)

static func wrap(x, a, b):
	if x < a:
		return x + abs(b - a)
	elif x > b:
		return x - abs(b - a)
	else:
		return x
	pass
