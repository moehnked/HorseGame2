extends WorldEnvironment

export var music_enabled = true
var args = {}
var callback = {}
var caller = {}
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.world = self
	rng.randomize()
	pass # Replace with function body.

func _process(delta):
	environment.background_sky.sun_latitude += 0.01

func create_point(point):
	var obj = load("res://prefabs/Misc/TestPoint.tscn").instance()
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
	var obj = load(ref).instance()
	print("creating object ", obj.name, " at ", location)
	call_deferred("add_child", obj)
	obj.global_transform.origin = location
	return obj

func queue_timer(_caller, time, _callback, args = {}):
	print("queuing timer for ", _caller.name, " to call ", _callback, " with ")
	print(args)
	if not $MiscTimer1.time_left > 0:
		$MiscTimer1.start(time)
		set_caller_and_callback(_caller, _callback, $MiscTimer1, args)
	else:
		if not $MiscTimer2.time_left > 0:
			$MiscTimer2.start(time)
			set_caller_and_callback(_caller, _callback, $MiscTimer1, args)
		else:
			if not $MiscTimer3.time_left > 0:
				$MiscTimer3.start(time)
				set_caller_and_callback(_caller, _callback, $MiscTimer1, args)

func set_caller_and_callback(_caller, _callback, timer, _args ):
	caller[timer] = _caller
	callback[timer] = _callback
	args[timer] = _args
	

func timer_timeout(timer):
	#caller.pop_front().call(callback.pop_front())
	print(args)
	if args.size() > 0:
		if args[timer] != null:
			if args[timer].keys().size() > 0:
				caller[timer].call(callback[timer], args[timer])
	else :
		print(callback[timer])
		caller[timer].call(callback[timer])
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
