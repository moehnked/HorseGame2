extends Area

var Utils = preload("res://Utils.gd")

var exit_callback
var playerRef
var rootRef
var power = 1

#func initialize(player, root, palm, callback, hand):
#	playerRef = player
#	rootRef = root
#	$TimeToLive.start()
#	global_transform.origin = palm.global_transform.origin
#	playerRef.call(callback)

func initialize(args):
	args = Utils.check(args, {'player':null, 'root':null, 'palm':null, 'callback':null, 'hand':null, 'exit_callback':null, 'scale':1.0})
	playerRef = args['player']
	rootRef = args['root']
	global_scale(Vector3(args.scale,args.scale,args.scale))
	$TimeToLive.start()
	global_transform.origin = args['palm'].global_transform.origin
	if(args['callback'] != null):
		playerRef.call(args.callback)
	exit_callback = args.exit_callback

func _on_TimeToLive_timeout():
	if(exit_callback == null):
		queue_free()
	else:
		playerRef.call_deferred(exit_callback)


func _on_Punch_area_entered(area):
	if(area.has_method("take_damage") && area != playerRef):
		print("punch hitbox hit: ", area)
		area.take_damage(power, playerRef)
	pass # Replace with function body.


func _on_Punch_body_entered(body):
	if(body.has_method("take_damage") && body != playerRef):
		print("punch hitbox hit: ", body)
		body.take_damage(power, self, playerRef)
	pass # Replace with function body.
