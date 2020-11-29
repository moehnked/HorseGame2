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
	if input.standard:
		charm_origin.call(callback, selected_charm)
		unsubscribe_to()
		queue_free()

func _process(delta):
	var offset = get_global_mouse_position() - $Ring.global_position
	var point = offset.normalized() * pointerRadius
	$Ring/Pointer.global_position = $Ring.global_position + point
	pass
