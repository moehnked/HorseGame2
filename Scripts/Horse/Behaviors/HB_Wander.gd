extends Node

var actor = null
var direction:Vector3 = Vector3()
var stateMachine = null
var velocity:Vector3 = Vector3()
var wanderToPoint:Vector3 = Vector3()


func initialize(args = {}):
	args = Utils.check(args, {"actor":actor, "stateMachine":get_parent()})
	actor = args.actor
	stateMachine = args.stateMachine
	#pick a random point
	choose_random_point()
	#start moving towards it
	var ac = actor.get_animation_controller()
	ac.play_animation("Walk")
	pass

func choose_random_point():
	var rng = Global.world.rng
	wanderToPoint = actor.global_transform.origin + (Vector3(rng.randf_range(-1,1),rng.randf_range(-1,1),rng.randf_range(-1,1)) * rng.randi_range(10,40))
	pass

func run(delta):
	#actor.rotation_degrees.y = Utils.angle_to(Vector2(actor.global_transform.origin.x, actor.global_transform.origin.z), Vector2(wanderToPoint.x, wanderToPoint.z))
	#actor.rotate_towards_point(actor.global_transform.origin.linear_interpolate(wanderToPoint, 0.01 * delta))
	actor.rotate_towards_point(wanderToPoint)
	direction = actor.global_transform.origin.direction_to(wanderToPoint)
	var movement = actor.move_at_speed({"dir":direction, "velocity":velocity, "delta":delta})
	if movement.position.distance_to(wanderToPoint) < 4:
		stateMachine.set_behaivor("Idle")
	pass
