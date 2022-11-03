#extends WorldEnvironment
extends Spatial

var args = {}
var callback = {}
var caller = {}
var rng = RandomNumberGenerator.new()
var deltaT = 0.0
var plantRot = 0.0
var saveQueue = []
var skipParams = [
	"breedMaterials", "Breeds","filename", "jumpSFX", "listItems","parent", "pos_x", "pos_y", "random_sounds", "rustleSFX", "hm", "HorseMoods",
	"nextHitSfx", "icon", "dialogueScreen"
]
var testPointRef = preload("res://prefabs/Misc/TestPoint.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.world = self
	rng.randomize()
	get_tree().call_group("rng_dependant", "initialize")
	pass # Replace with function body.

func _process(delta):
	deltaT += delta
	plantRot = sin(deltaT)
	get_tree().call_group("Wiggle", "wiggle", plantRot)
	pass

func get_wiggle_rot():
	return plantRot

func add_child( node, legible_unique_name=false, forceTopLevel = false):
	if forceTopLevel:
		.add_child(node, legible_unique_name)
		node.owner = self
	elif node.is_in_group("UI_Special"):
		.add_child(node,legible_unique_name)
		node.owner = self
	else:
		$ViewportContainer2/Viewport.add_child(node, legible_unique_name)
		node.owner = self
	return node

func add_child_ui(node, legible_unique_name=false):
	$ViewportContainer/Viewport.add_child(node, legible_unique_name)
	node.owner = self

func add_to_save_queue(node):
	saveQueue.append(node)

func call_no_args(timer):
	if callback.keys().has(timer) and caller.keys().has(timer):
		print("[world]: ",caller[timer], " calling ", callback[timer])
		caller[timer].call(callback[timer])

func create_point(point):
	var obj = testPointRef.instance()
	obj.global_transform.origin = point
	add_child(obj)
	return obj

func get_random_float():
	return rng.randf()

func get_rng():
	return rng

func ignore_unique():
	return true

func instantiate(ref, location = Vector3()):
	if ref is String:
		ref = load(ref)
	var obj = ref.instance() if ref is Resource else ref
	call("add_child", obj)
	if obj is Spatial:
		obj.global_transform.origin = location
	return obj

func instance_resource(res, location = Vector3()):
	var obj = res.instance()
	print("creating object from resource  ", obj.name, " at ", location)
	call("add_child", obj)
	if obj is Spatial:
		obj.global_transform.origin = location
	return obj

func load_world():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.
	
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for i in save_nodes:
		i.free()
	save_game.open("user://savegame.save", File.READ)
	while save_game.get_position() < save_game.get_len():
		#save_nodes = get_tree().get_nodes_in_group("Persist")
		var new_object = save_game.get_var(true)
		add_child(new_object)
		# Firstly, we need to create the object and add it to the tree and set its position.
		#var new_object = load(node_data["filename"]).instance()
	save_game.close()
	

func load_game():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.

	# We need to revert the game state so we're not cloning objects
	# during loading. This will vary wildly depending on the needs of a
	# project, so take care with this step.
	# For our example, we will accomplish this by deleting saveable objects.
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for i in save_nodes:
		i.queue_free()

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	save_game.open("user://savegame.save", File.READ)
	var dataDicts = []
	while save_game.get_position() < save_game.get_len():
		# Get the saved dictionary from the next line in the save file
		var node_data = parse_json(save_game.get_line())
		dataDicts.append(node_data)
	#dataDicts.sort_custom(self,"sorter_data_dicts")
	print(dataDicts)
	for node_data in dataDicts:
		#check thru persistent nodes
		var reinstancedCount = 0
		var percs = get_tree().get_nodes_in_group("Persist")
		var new_object = null
		for n in percs:
			#if a node has already been reinstanced, a node with the same path as the savadata's nodepath will exist
			var npath = n.get_path()
			if npath == node_data["nodePath"]:
				#so we can just set the data on that node
				#n.free()
				reinstancedCount += 1
				new_object = n
		#else, we are looking at a persistent object that has not yet been reinstanced after the intial clean
		if reinstancedCount == 0:
			new_object = load(node_data["filename"]).instance()
		var new_obj_type = typeof(new_object)
		print(new_obj_type)
		if new_obj_type != TYPE_NIL:
			set_persistent_node_data(node_data, new_object, reinstancedCount > 0)
#			if node_data["isInTree"] == false:
#				var nop = new_object.get_parent()
#				if nop != null:
#					nop.remove_child(new_object)

	save_game.close()
	get_tree().call_group("LoadComplete", "on_load_complete")

func place(obj, location = Vector3()):
	call_deferred("add_child", obj)
	if obj is Spatial:
		obj.global_transform.origin = location
	return obj

func queue_timer(_caller, time, _callback, args = {}):
	var t = get_tree().create_timer(time)
	t.connect("timeout", self, "timer_timeout", [t])
	set_caller_and_callback(_caller, _callback, t, args)

func save_world():
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		if node.filename.empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue
		# Check the node has a save function.
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue
		
		# Call the node's save function.
		var node_data = node.call("save")
		# Store the save dictionary as a new line in the save file.
		save_game.store_line(to_json(node_data))
	for n in saveQueue:
		if n.filename.empty():
			print("persistent node '%s' is not an instanced scene, skipped" % n.name)
			continue
		# Check the node has a save function.
		if !n.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % n.name)
			continue
		var node_data = n.call("save")
		# Store the save dictionary as a new line in the save file.
		save_game.store_line(to_json(node_data))
		
	save_game.close()

func save_world_objects():
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	save_nodes.sort_custom(self, "sorter_percs")
	for node in save_nodes:
		if node.filename.empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue
		# Check the node has a save function.
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue
		
		# Call the node's save function.
		#var node_data = node.call("save")
		# Store the save dictionary as a new line in the save file.
		save_game.store_var(node, true)
	save_game.close()
	

func set_persistent_node_data(node_data, new_object, skipNodeAdd = false):
	if new_object == null:
		return
	if node_data["isInTree"] == false:
		print(node_data["itemName"])
	if node_data["isInTree"] == true:
		if not skipNodeAdd:
			var p = get_node(node_data["parent"])
			if p != null:
				p.add_child(new_object, true)
			else:
				p = get_node(node_data["oldOwner"])
				if p != null:
					p.add_child(new_object, true)
				else:
					add_child(new_object, true)
		if new_object is Spatial:
			new_object.global_transform.basis = Utils.basis_from_ar(node_data['basis'])
			new_object.global_transform.origin = Vector3(node_data['posx'],node_data['posy'],node_data['posz'])
	new_object.set_name(node_data["nodeName"])
	new_object.owner = self
	# Now we set the remaining variables.
	for i in node_data.keys():
		if skipParams.has(i):
			continue
		else:
			Utils.set_prop(new_object, i, node_data[i])
	if node_data["isInTree"] == false:
		new_object.add_self_to_inventory(new_object.controller, true)
	elif "controller" in new_object:
		if new_object.controller != null:
			new_object.add_self_to_inventory(new_object.controller, true)
	pass

func set_caller_and_callback(_caller, _callback, timer, _args ):
	caller[timer] = _caller
	callback[timer] = _callback
	args[timer] = _args

func sorter_percs(a, b):
	if a.has_method("get_load_priority"):
		if b.has_method("get_load_priority"):
			if a.get_load_priority() > b.get_load_priority():
				return true
			else:
				return false
		else:
			return true
	else:
		return false
	

func sorter_data_dicts(a, b):
	var aRef = load(a["filename"]).instance()
	var bRef = load(b["filename"]).instance()
	if aRef.has_method("get_load_priority"):
		if bRef.has_method("get_load_priority"):
			if aRef.get_load_priority() < bRef.get_load_priority():
				return true
			else:
				return false
		else:
			return true
	else:
		return false

func trigger_event(groupName, triggerer = add_child(Node.new())):
	print("world: trrigering event group ", groupName, typeof(groupName))
	get_tree().call_group(groupName, "trigger", triggerer)
	pass

func timer_timeout(timer):
	if args.keys().has(timer):
		if args[timer] != null:
			if args[timer].keys().size() > 0:
				caller[timer].call(callback[timer], args[timer])
			else:
				call_no_args(timer)
		else:
			call_no_args(timer)
	else :
		call_no_args(timer)
	caller.erase(timer)
	callback.erase(timer)
	args.erase(timer)

func _on_MiscTimer1_timeout():
	timer_timeout($MiscTimer1)
	pass # Replace with function body.

func _on_MiscTimer2_timeout():
	timer_timeout($MiscTimer2)
	pass # Replace with function body.

func _on_MiscTimer3_timeout():
	timer_timeout($MiscTimer3)
	pass # Replace with function body.

func _on_SunTick_timeout():
	#environment.background_sky.sun_latitude += 0.1
	#environment.background_sky.sky_energy = Utils.custom_function_env_light(environment.background_sky.sun_latitude)
	#print(environment.background_sky.sky_energy)
	#$SunTick.start()
	pass # Replace with function body.
