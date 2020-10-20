extends Spatial

var _callback
var _hand
var creation_prefab
var playerRef
var rootRef
var rotationOffset = 0
var valid = true
var previousMouseY


func initialize(player, world, prefab, callback, hand):
	creation_prefab = prefab
	rootRef = world
	playerRef = player
	_callback = callback
	_hand = hand
	subscribe_to()


func parse_input(input):
	match _hand:
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
	var p = load("res://prefabs/Constructable/" + creation_prefab + ".tscn").instance()
	p.global_transform = global_transform
	rootRef.call_deferred("add_child", p)
	playerRef.exit_build_mode(_callback)
	playerRef.placer_unsubscribe(self)
	playerRef.isBuilding = false
	unsubscribe_to()
	playerRef.conclude_spell("BUILD")
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
