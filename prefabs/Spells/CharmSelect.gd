extends Control

var source
var callback
var pointerRadius = 50
var selected_charm
var charm_origin

func update_selected_charm(charm):
	selected_charm = charm

func subscribe_to():
	Global.InputObserver.subscribe(self)

func unsubscribe_to():
	Global.InputObserver.unsubscribe(self)
	
func initialize(args = {}):
	args = Utils.check(args, {'source':null, 'palm':null, 'callback':"", 'hand':null, 'charm_origin':null})
	source = args.source
	callback = args.callback
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	subscribe_to()
	charm_origin = args.charm_origin

func parse_input(input):
	if input.standard or Input.is_action_just_released("ui_accept") or input.special:
		charm_origin.call(callback, selected_charm)
		unsubscribe_to()
		queue_free()

func _process(delta):
	var joypointr = Vector2(Input.get_joy_axis(0, JOY_ANALOG_RX), Input.get_joy_axis(0, JOY_ANALOG_RY))
	var joypointl = Vector2(Input.get_joy_axis(0, JOY_ANALOG_LX), Input.get_joy_axis(0, JOY_ANALOG_LY))
	var joypoint = joypointr if joypointr.length() > joypointl.length() else joypointl
	if joypoint.length() > 0.2:
		$Ring/Pointer.global_position = $Ring.global_position + (joypoint * pointerRadius)
	else:
		var offset = get_global_mouse_position() - $Ring.global_position
		var point = offset.normalized() * pointerRadius
		$Ring/Pointer.global_position = $Ring.global_position + point
	pass
