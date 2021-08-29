extends Control
var Utils = preload("res://Utils.gd")

var callback
var canSelect = false
var buildList = []
var hand
var playerRef
var pointerRadius = 100
var rootRef
var selected
var state = 0
var tempRot

func _ready():
	$Container/Ring/Pointer.initialize(self)

func _process(delta):
	#print(get_global_mouse_position())
	var offset = get_global_mouse_position() - $Container/Ring.global_position
	var point = offset.normalized() * pointerRadius
	$Container/Ring/Pointer.global_position = $Container/Ring.global_position + point
	pass

func _on_ReadyWait_timeout():
	canSelect = true
	pass # Replace with function body.

func check_permit():
	return Utils.contains("Building Permit", playerRef.get_inventory())

func exit():
	playerRef.exit_build_mode(callback)
	playerRef.placer_unsubscribe(self)
	playerRef.isBuilding = false
	unsubscribe_to()
	playerRef.conclude_spell("BUILD")
	playerRef.exit_some_menu()
	queue_free()

func get_build_list():
	buildList = playerRef.buildList
	var i = 0
	var offset_theta = 40
	for b in buildList:
		var button = load("res://prefabs/UI/BuildOption.tscn").instance()
		button.initialize(b, self)
		var offset = $Container/Ring.position
		offset.y += pointerRadius * sin(deg2rad(offset_theta * i))
		offset.x += pointerRadius * cos(deg2rad(offset_theta * i))
		button.position = offset
		$Container.add_child(button)
		selected = button
		i += 1

func initialize(args):
	args = Utils.check(args, {'player':null, 'root':null, 'palm':null, 'callback':null, 'hand':null})
	playerRef = args.player
	rootRef = args.root
	hand = args.hand
	callback = args.callback
	if not check_permit():
		exit()
		return
	Utils.show_mouse()
	get_build_list()
	subscribe_to()
	playerRef.isBuilding = true
	playerRef.enter_some_menu()

func parse_input(input):
	if input.mouse_down:
		print("build mode - mouse down")
		exit()
	if input.standard:
		if canSelect:
			ready_placer()

func ready_placer():
	var p = load("res://prefabs/Constructable/" + selected.prefab + "_Placer.tscn").instance()
	p.initialize({'player':playerRef, 'world':rootRef, 'prefab':selected.prefab, 'callback':callback, 'hand':hand})
	Global.world.call_deferred("add_child", p)
	playerRef.placer_subscribe(p)
	playerRef.return_control()
	unsubscribe_to()
	Utils.capture_mouse()
	queue_free()

func subscribe_to():
	Global.InputObserver.subscribe(self)

func unsubscribe_to():
	Global.InputObserver.unsubscribe(self)
