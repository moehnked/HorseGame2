extends "res://Scripts/Horse/Behaviors/HorseBehavior.gd"

var direction:Vector3 = Vector3()
var velocity:Vector3 = Vector3()
var wanderToPoint:Vector3 = Vector3()


func initialize(args = {}):
	print("initializing wandering")
	args = .initialize(args)
	choose_random_point()
	var ac = actor.get_animation_controller()
	ac.play_animation("Walk")
	velocity = Vector3.ZERO
	pass

func choose_random_point():
	var rng = Global.world.rng
	#wanderToPoint = actor.global_transform.origin + (Vector3(rng.randf_range(-1,1) * rng.randi_range(10,60),rng.randf_range(-1,1),rng.randf_range(-1,1)) * rng.randi_range(10,60))
	wanderToPoint = actor.global_transform.origin
	wanderToPoint = wanderToPoint + Vector3(rng.randf_range(-30,30), rng.randf_range(-1,1), rng.randf_range(-30,30))
	pass

func run(delta):
	actor.rotate_towards_point(wanderToPoint)
	direction = actor.global_transform.origin.direction_to(wanderToPoint)
	var speed = clamp(actor.stats.speed * 0.1, 0.3,1.0)
	var movement = actor.move_at_speed({"dir":direction, "velocity":velocity, "delta":delta, "speed":speed, "directionIsNormalized":true})
	velocity = movement.velocity
	if movement.position.distance_to(wanderToPoint) < 10:
		exit_state("wander")
	pass

func wander():
	stateMachine.set_behavior({"behaviorName":"Idle"})
