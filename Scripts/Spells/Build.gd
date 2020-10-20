extends Control

var playerRef
var rootRef
var pointerRadius = 100
var buildList = []
var selected
var tempRot
var canSelect = false
var _callback
var _hand

var state = 0

func initialize(player, root, palm, callback, hand):
	playerRef = player
	rootRef = root
	_hand = hand
	_callback = callback
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	playerRef.isBuilding = true
	get_build_list()
	subscribe_to()
	playerRef.revoke_casting()
	
func subscribe_to():
	rootRef.get_node("InputObserver").subscribe(self)

func unsubscribe_to():
	rootRef.get_node("InputObserver").unsubscribe(self)

func parse_input(input):
	if input.standard:
		if canSelect:
			ready_placer()

func ready_placer():
	print(selected)
	var p = load("res://prefabs/Constructable/" + selected.prefab + "_Placer.tscn").instance()
	p.initialize(playerRef, rootRef, selected.prefab, _callback, _hand)
	rootRef.call_deferred("add_child", p)
	playerRef.placer_subscribe(p)
	#playerRef.isBuilding = true
	unsubscribe_to()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	queue_free()

func get_build_list():
	buildList = playerRef.buildList
	var i = 0
	var offset_theta = 40
	for b in buildList:
		print("button ",i)
		var button = load("res://prefabs/UI/BuildOption.tscn").instance()
		button.initialize(b, self)
		var offset = $Container/Ring.position
		offset.y += pointerRadius * sin(deg2rad(offset_theta * i))
		offset.x += pointerRadius * cos(deg2rad(offset_theta * i))
		print(offset)
		button.position = offset
		$Container.add_child(button)
		selected = button
		i += 1
	
func _process(delta):
	print(get_global_mouse_position())
	var offset = get_global_mouse_position() - $Container/Ring.global_position
	var point = offset.normalized() * pointerRadius
	$Container/Ring/Pointer.global_position = $Container/Ring.global_position + point
	pass


func _on_ReadyWait_timeout():
	print("yada")
	playerRef.isBuilding = false
	canSelect = true
	pass # Replace with function body.
