extends Area

export(Resource) var resource_ref

var valid = preload("res://Materials/construction_valid.tres")
var invalid = preload("res://Materials/construction_invalid.tres")

export var required_materials = 5   #number of planks required to build

var callback
var creation_prefab
var hand
var isRotating = false
var isSnapped = false
var previousMouseY
var placeable = true
var rotationOffset = 0
var snapOffset = 0
var touching = []

func check_can_build():
	if Global.Player.hasBuildingRights:
		return true
	else:
		return false

func check_materials():
	var inv = Global.Player.get_inventory()
	var mat = resource_ref.instance()
	var count = Utils.count(mat, inv)
	if count >= required_materials:
		return true
	else:
		return false

func consume_materials():
	var inv = Global.Player.get_inventory()
	var mat = resource_ref.instance()
	var i = 0
	while(Utils.count(mat, inv) > 0 and i < required_materials):
		i += 1
		Utils.remove_item(mat, inv)

func disable_place():
	#print("cannot place item here")
	placeable = false
	for o in get_meshes():
		o.material_override = invalid

func enable_place():
	placeable = true
	for o in get_meshes():
		o.material_override = valid

func get_meshes():
	var m = []
	for i in get_children():
		if i is MeshInstance:
			m.append(i)
	return m

func initialize(args):
	args = Utils.check(args, {'prefab':null, 'callback':null, 'hand':null})
	creation_prefab = args.prefab
	callback = args.callback
	hand = args.hand
	#resource_ref = load("res://prefabs/Items/Plank.tscn")
	subscribe_to()

func parse_input(input):
	if(check_materials() and check_can_build()):
		enable_place()
	else:
		disable_place()
	if(input.tab):
		terminate()
	match hand:
		"left":
			if input.standard:
				spawn_prefab()
			if Input.is_action_pressed("special"):
				update_rotation(input)
			if input.special:
				snap()
		"right":
			if input.special:
				spawn_prefab()
			if Input.is_action_pressed("standard"):
				update_rotation(input)
			if input.standard:
				snap()

func parse_raycast(raycastobj, builder_pos):
	update_position(raycastobj.get_collision_point(), builder_pos)
	var col = raycastobj.get_collider()
	if col.has_method("deconstruct"):
		rotation.y = col.rotation.y + snapOffset
		isSnapped = true
	else:
		isSnapped = false
	pass

func snap():
	if isSnapped:
		snapOffset += PI / 2
		rotationOffset = 0

func spawn_prefab():
	print("PLACER: spawning")
	if(placeable and check_can_build()):
		print("PLACER: self is placable and Player has building rights")
		#if check_materials():
		var p = load("res://prefabs/Constructable/" + creation_prefab + ".tscn").instance()
		p.global_transform = global_transform
		Global.world.call_deferred("add_child", p)
		consume_materials()
	elif not check_can_build():
		Global.InteractionPrompt.show_context("Cannot Build: You do not have Building Rights...")
	elif not check_materials():
		Global.InteractionPrompt.show_context("Cannot Build: Insufficient Materials")	#else:
			#print("PLACER: insufficient mats")
	terminate()

func subscribe_to():
	Global.InputObserver.subscribe(self)

func terminate():
	var player = Global.Player
	player.exit_build_mode(callback)
	player.placer_unsubscribe(self)
	player.isBuilding = false
	unsubscribe_to()
	player.conclude_spell("BUILD")
	player.exit_some_menu()
	queue_free()

func unsubscribe_to():
	Global.InputObserver.unsubscribe(self)

func update_position(point, builder_pos):
	global_transform.origin = point
	var x = builder_pos.x - point.x
	var y = builder_pos.z - point.z
	rotation_degrees.y = rad2deg(atan2(x,y) + 90) + rotationOffset

func update_rotation(input):
	isRotating = true
	if not isSnapped :
		rotationOffset += 3

func _on_Fence_Placer_area_entered(area):
	if(area.has_method("link")):
		if(area.leftLink != null and area.rightLink != null):
			touching.append(area)
			disable_place()
	elif(area.owner.has_method("link")):
		if(area.owner.leftLink != null and area.owner.rightLink != null):
			touching.append(area)
			disable_place()


func _on_Fence_Placer_area_exited(area):
	touching.remove(touching.find(area))
	if(touching.size() <= 0):
		enable_place()
	pass # Replace with function body.
