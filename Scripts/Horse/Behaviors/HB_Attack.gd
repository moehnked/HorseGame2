extends "res://Scripts/Horse/Behaviors/HorseBehavior.gd"

var distanceToTarget = 1000
var state = States.none
var target
var velocity = Vector3.ZERO
var d = 25

enum States{aggroing, approaching, strafing, none, attack, lag}

func initialize(args = {}):
	.initialize(args)
	target = args["target"]
	state = args["state"]
	if state == States.strafing:
		$StrafeTimer.start(Utils.rand_float_range(2.0,5.0))
		set_animation("Trot", 1.0)

func get_strafe_dir():
	var s = actor.global_transform.origin
	var t = target.global_transform.origin
	var oldDisplacement = Vector2(t.x, t.z) - Vector2(s.x, s.z)
	var radius = oldDisplacement.length()
	var oldAngle = atan2(oldDisplacement.y, oldDisplacement.x)
	var angleDis = (d / (2.0 * PI * radius)) * 360.0
	var newPoint = t + Vector3((radius * cos(oldAngle + angleDis)), 0, (radius * sin(oldAngle + angleDis)))
	#return s.direction_to(newPoint)
	return newPoint if actor.get_EVRC().outputEV.length() == 0 else -actor.get_EVRC().outputEV

func run(delta):
	if target == null:
		actor.exit_pilot()
	match state:
		States.aggroing:
			#move_towards_target()
			actor.enter_walk_to({"target":target,
				"minDist": 20,
				"isRunning": true,
				"callback": "attack", 
				"kargs":{"target":target, 
					"state":States.strafing
					}
				})
		States.approaching:
			actor.enter_walk_to({"target":target,
				"minDist": 3,
				"isRunning": true,
				"callback": "attack", 
				"kargs":{"target":target, 
					"state":States.attack
					}
				})
		States.attack:
			actor.get_animation_controller().play_random_attack()
			state = States.lag
		States.strafing:
			strafe(delta)
		States.lag:
			if actor.get_animation_controller().attackAnimationFinished:
				actor.attack({"target":target, 
					"state":States.strafing
					})
	pass

func save():
	return Utils.serialize_node(self, {"actor": actor.get_uid() if actor != null else null})

func set(param, val):
	match param:
		"state":
			state = int(val)
		_:
			.set(param, val)

func set_animation(animName = "Idle", spd = 1.0):
	var ac = actor.get_animation_controller()
	ac.play_animation(animName)
	ac.set_playback_speed(spd)

func strafe(delta):
	var direction = get_strafe_dir()
	var movement = actor.move_at_speed({"dir":direction, "velocity":velocity, "delta":delta, "speed": actor.stats.speed})
	actor.rotate_towards_point(target.global_transform.origin, 1)
	velocity = movement.velocity


func _on_StrafeTimer_timeout():
	state = States.approaching
	pass # Replace with function body.
