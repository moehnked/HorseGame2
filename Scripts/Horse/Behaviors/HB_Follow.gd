extends "res://Scripts/Horse/Behaviors/HorseBehavior.gd"

var target = null
var velocity:Vector3 = Vector3()
var walkThresh:int = 7
var trotThresh:int = 14

func check_distance(from, to, thresh):
	return from.global_transform.origin.distance_to(to.global_transform.origin) > thresh

func initialize(args = {}):
	args = .initialize(args)
	target = args.target
	trotThresh += actor.stats['speed']
	walkThresh += actor.stats['speed']
	pass

func set_animation(animName = "Idle", spd = 1.0):
	var ac = actor.get_animation_controller()
	ac.play_animation(animName)
	ac.set_playback_speed(spd)
	

func run(delta):
	#velocity = actor.apply_gravity(velocity, delta)
	var speed = 1
	if check_distance(actor, target, trotThresh):
		speed = actor.stats['speed']
		set_animation("Trot")
		trotThresh = 6
	elif check_distance(actor, target, walkThresh):
		walkThresh = 5
		speed = clamp(actor.stats['speed'] * 0.5, 0.5, 1.0)
		set_animation("Walk")
	else:
		walkThresh = 7
		trotThresh = 14
		speed = 0
		set_animation("Idle")
	actor.rotate_towards_point(target.global_transform.origin, 0.3)
	var direction = actor.global_transform.origin.direction_to(target.global_transform.origin)
	var movement = actor.move_at_speed({"dir":direction, "velocity":velocity, "delta":delta, "speed": speed, "directionIsNormalized":true})
	velocity = movement.velocity
	pass
