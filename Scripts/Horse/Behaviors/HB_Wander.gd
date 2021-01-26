extends "res://Scripts/Horse/Behaviors/HorseBehavior.gd"

var direction:Vector3 = Vector3()
var velocity:Vector3 = Vector3()
var wanderToPoint:Vector3 = Vector3()


func initialize(args = {}):
	args = .initialize(args)
	choose_random_point()
	var ac = actor.get_animation_controller()
	ac.play_animation("Walk")
	pass

func choose_random_point():
	var rng = Global.world.rng
	wanderToPoint = actor.global_transform.origin + (Vector3(rng.randf_range(-1,1),rng.randf_range(-1,1),rng.randf_range(-1,1)) * rng.randi_range(10,60))
	pass

func run(delta):
	actor.rotate_towards_point(wanderToPoint)
	direction = actor.global_transform.origin.direction_to(wanderToPoint)
	var movement = actor.move_at_speed({"dir":direction, "velocity":velocity, "delta":delta})
	if movement.position.distance_to(wanderToPoint) < 10:
		stateMachine.set_behavior({"behaviorName":"Idle"})
	pass
