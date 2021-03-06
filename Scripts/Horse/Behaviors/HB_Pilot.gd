extends "res://Scripts/Horse/Behaviors/HorseBehavior.gd"

var input:InputMacro = InputMacro.new()
var velocity:Vector3 = Vector3()
var wanderToPoint:Vector3 = Vector3()

func apply_rotation(delta):
	#var rot = deg2rad(actor.rotation_degrees.y)
	#actor.rotate_y(Utils.interpolation(0, input.mouse_horizontal * 10, delta))
	actor.rotate_y(input.mouse_horizontal)

func initialize(args = {}):
	args = .initialize(args)
	Global.InputObserver.subscribe(self)
	pass

func parse_input(_input):
	input = _input

func parse_movement(actor, delta):
	var direction = Vector3()
	var aim = actor.global_transform.basis
	if input.forward:
		direction -= aim.z
	if input.backward:
		direction += aim.z
	if input.left:
		direction -= aim.x
	if input.right:
		direction += aim.x
	direction.y = 0
	direction = direction.normalized()
	return direction

func run(delta):
	apply_rotation(delta)
	var direction = parse_movement(actor, delta)
	update_animation(direction)
	var movement = actor.move_at_speed({"dir":direction, "velocity":velocity, "delta":delta, "jump":input.space})
	velocity = movement.velocity
	if movement.position.distance_to(wanderToPoint) < 4:
		stateMachine.set_behaivor("Idle")
	pass

func update_animation(direction):
	if direction.z != 0:
		actor.get_animation_controller().play_animation("Trot")
	elif direction.x != 0:
		actor.get_animation_controller().play_animation("Walk")
	else:
		actor.get_animation_controller().play_animation("Idle")
	pass
