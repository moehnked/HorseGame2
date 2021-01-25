extends "res://Scripts/Horse/Behaviors/HorseBehavior.gd"

var callback = "enter_idle"
var callback_kargs = {}
var target = null
var velocity:Vector3 = Vector3()

func check_distance(from, to, thresh):
	return from.global_transform.origin.distance_to(to.global_transform.origin) > thresh

func initialize(args = {}):
	args = .initialize(args)
	target = args.target
	callback = args.callback
	callback_kargs = args.kargs
	set_animation("Walk")
	pass

func set_animation(animName = "Idle", spd = 1.0):
	var ac = actor.get_animation_controller()
	ac.play_animation(animName)
	ac.set_playback_speed(spd)

func run(delta):
	var speed = 1
	actor.rotate_towards_point(target.global_transform.origin, 0.02)
	var direction = actor.global_transform.origin.direction_to(target.global_transform.origin)
	var movement = actor.move_at_speed({"dir":direction, "velocity":velocity, "delta":delta, "speed": speed})
	if not check_distance(actor, target, 1):
		if callback_kargs.keys().size() > 0:
			actor.call(callback, callback_kargs)
		else:
			actor.call(callback)
	pass
