extends Control

var playerRef
var rootRef
var _callback
var _hand
var pointerRadius = 50
var selected_charm
var charm_source

func update_selected_charm(charm):
	selected_charm = charm

func subscribe_to():
	rootRef.get_node("InputObserver").subscribe(self)

func unsubscribe_to():
	rootRef.get_node("InputObserver").unsubscribe(self)
	
func initialize(player, root, palm, callback, hand, charm_origin):
	playerRef = player
	rootRef = root
	_callback = callback
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	subscribe_to()
	charm_source = charm_origin

func parse_input(input):
	if input.standard:
		charm_source.call(_callback, selected_charm)
		unsubscribe_to()
		queue_free()

func _process(delta):
	var offset = get_global_mouse_position() - $Ring.global_position
	var point = offset.normalized() * pointerRadius
	$Ring/Pointer.global_position = $Ring.global_position + point
	pass
