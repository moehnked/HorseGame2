extends WorldEnvironment

var args = {}
var callback = {}
var caller = {}
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.world = self
	rng.randomize()
	get_tree().call_group("rng_dependant", "initialize")
	pass # Replace with function body.

func call_no_args(timer):
	if callback.keys().has(timer) and caller.keys().has(timer):
		print("[world]: ",caller[timer], " calling ", callback[timer])
		caller[timer].call(callback[timer])

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

func instance_resource(res, location = Vector3()):
	var obj = res.instance()
	print("creating object from resource  ", obj.name, " at ", location)
	call_deferred("add_child", obj)
	obj.global_transform.origin = location
	return obj

func place(obj, location = Vector3()):
	call_deferred("add_child", obj)
	obj.global_transform.origin = location
	return obj

func queue_timer(_caller, time, _callback, args = {}):
	print("queuing timer for ", _caller.name, " to call ", _callback, " with ")
	print(args)
	if $MiscTimer1.is_stopped():
		$MiscTimer1.start(time)
		set_caller_and_callback(_caller, _callback, $MiscTimer1, args)
	else:
		if $MiscTimer2.is_stopped():
			$MiscTimer2.start(time)
			set_caller_and_callback(_caller, _callback, $MiscTimer1, args)
		else:
			if $MiscTimer3.is_stopped():
				$MiscTimer3.start(time)
				set_caller_and_callback(_caller, _callback, $MiscTimer1, args)

func set_caller_and_callback(_caller, _callback, timer, _args ):
	caller[timer] = _caller
	callback[timer] = _callback
	args[timer] = _args
	

func timer_timeout(timer):
	if args.keys().has(timer):
		if args[timer] != null:
			if args[timer].keys().size() > 0:
				caller[timer].call(callback[timer], args[timer])
			else:
				call_no_args(timer)
		else:
			call_no_args(timer)
	else :
		call_no_args(timer)
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

func _on_SunTick_timeout():
	#environment.background_sky.sun_latitude += 0.1
	#environment.background_sky.sky_energy = Utils.custom_function_env_light(environment.background_sky.sun_latitude)
	#print(environment.background_sky.sky_energy)
	#$SunTick.start()
	pass # Replace with function body.
