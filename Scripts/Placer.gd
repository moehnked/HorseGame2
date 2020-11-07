extends Area
var Utils = preload("res://Utils.gd")

var callback
var creation_prefab
var hand
var playerRef
var previousMouseY
var rootRef
var rotationOffset = 0
var touching = []
var valid = true

func disable_place():
	print("cannot place item here")
	valid = false
	$MeshInstance.get_surface_material(0).albedo_color = Color(1.0,0.0,0.0,0.63)

func enable_place():
	valid = true
	$MeshInstance.get_surface_material(0).albedo_color = Color(0.0,1.0,0.0,0.63)

func initialize(args):
	args = Utils.check(args, {'player':null, 'world':null, 'prefab':null, 'callback':null, 'hand':null})
	creation_prefab = args.prefab
	rootRef = args.world
	playerRef = args.player
	callback = args.callback
	hand = args.hand
	subscribe_to()

func parse_input(input):
	match hand:
		"left":
			if input.standard:
				spawn_prefab()
			if Input.is_action_pressed("special"):
				update_rotation(input)
		"right":
			if input.special:
				spawn_prefab()
			if Input.is_action_pressed("standard"):
				update_rotation(input)

func spawn_prefab():
	if(valid):
		var p = load("res://prefabs/Constructable/" + creation_prefab + ".tscn").instance()
		p.global_transform = global_transform
		rootRef.call_deferred("add_child", p)
		playerRef.exit_build_mode(callback)
		playerRef.placer_unsubscribe(self)
		playerRef.isBuilding = false
		unsubscribe_to()
		playerRef.conclude_spell("BUILD")
		playerRef.exit_some_menu()
		queue_free()

func subscribe_to():
	rootRef.get_node("InputObserver").subscribe(self)

func unsubscribe_to():
	rootRef.get_node("InputObserver").unsubscribe(self)

func update_position(point, builder_pos):
	global_transform.origin = point
	var x = builder_pos.x - point.x
	var y = builder_pos.z - point.z
	rotation_degrees.y = rad2deg(atan2(x,y) + 90) + rotationOffset

func update_rotation(input):
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
