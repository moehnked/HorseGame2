extends "res://Scripts/Behavior/BehaviorState.gd"

class_name HorseState_Moving

var actor
var callback
var callback_kargs
var direction:Vector3 = Vector3()
var followingTarget
var is_running
var stopFollowThreshold
var velocity:Vector3 = Vector3()


func run_state(actor, delta):
	walk_towards(followingTarget, delta)
	pass

func initialize(args={}):
	args = Utils.check(args, {'target':null, 'thresh' : 20, 'callback' : "", 'is_running' : false, 'kargs' : null})
	callback = args.callback
	is_running = args.is_running
	actor = args.actor
	if(followingTarget != null):
		if(followingTarget.has_method("is_test_point")):
			followingTarget.queue_free()
			followingTarget = null
			pass

	if(args.target == self):
		print("! you can't walk towards yourself, you dummy!")
		actor.start_wandering()
	else:
		actor.stop_all_timers()
		followingTarget = args.target
		callback = args.callback
		callback_kargs = args.kargs
		stopFollowThreshold = args.thresh
		start_running() if args.is_running else start_walking()
		print("departing from ", actor.global_transform.origin, " - must travel : ", actor.report_distance(followingTarget))

func start_running():
	print("starting to run to ", followingTarget.name)
	if(followingTarget == actor.get_trainer):
		stopFollowThreshold = 10
	actor.set_animation("Trot", clamp(actor.stats.Speed * 0.6,1.0,4))

func start_walking():
	print("starting to walk to ", followingTarget.name)
	actor.set_animation("Walk", clamp(actor.stats.Speed * 0.3, 1.0,3.0))

func walk_towards(other, delta):
	actor.turn_and_face(other)
	direction = Vector3()
	var aim = actor.global_transform.basis
	direction -= aim.z
	direction.y = 0
	direction = direction.normalized()
	
	var h_velocity = velocity
	h_velocity.y = 0
	var movement = direction * actor.stats.Speed * 1.1
	
	var acceleration
	if direction.dot(h_velocity) > 0:
		acceleration = actor.MAX_ACCEL
	else:
		acceleration = actor.DEACCEL
		
	h_velocity = h_velocity.linear_interpolate(movement, acceleration * delta)
	velocity.x = h_velocity.x
	velocity.z = h_velocity.z
	velocity.y = actor.velocity.y
	velocity = actor.move_and_slide(velocity, Vector3.UP)
	actor.velocity = velocity
	var dist = actor.report_distance(followingTarget)
	if(dist < stopFollowThreshold):
		if(callback != ""):
			print("transitioning to ", callback, " - ", callback_kargs)
			actor.call(callback, callback_kargs) if (callback_kargs != null) else actor.call(callback)
		else:
			actor.set_animation("Idle", 0)
			actor.set_behavior("None")
	elif(actor.keepFollowing):
		if(dist > actor.followThreshold):
			print("too far away to walk, gotta run")
			actor.look_for({'target': other})
