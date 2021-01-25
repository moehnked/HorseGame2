extends "res://Scripts/Horse/Behaviors/HorseBehavior.gd"

var target = null
var velocity:Vector3 = Vector3()
var walkThresh:int = 5
var trotThresh:int = 10

func check_distance(from, to, thresh):
	return from.global_transform.origin.distance_to(to.global_transform.origin) > thresh

func initialize(args = {}):
	args = .initialize(args)
	target = args.target
	pass

func set_animation(animName = "Idle", spd = 1.0):
	var ac = actor.get_animation_controller()
	ac.play_animation(animName)
	ac.set_playback_speed(spd)
	

func run(delta):
	var speed = 1
	if check_distance(actor, target, trotThresh):
		speed = 10
		set_animation("Trot")
		trotThresh = 6
	elif check_distance(actor, target, walkThresh):
		trotThresh = 15
		speed = 2
		set_animation("Walk")
	else:
		walkThresh = 5
		speed = 0
		set_animation("Idle")
	actor.rotate_towards_point(target.global_transform.origin)
	var direction = actor.global_transform.origin.direction_to(target.global_transform.origin)
	var movement = actor.move_at_speed({"dir":direction, "velocity":velocity, "delta":delta, "speed": speed})
	pass
