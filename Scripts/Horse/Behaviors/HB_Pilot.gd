extends "res://Scripts/Horse/Behaviors/HorseBehavior.gd"

var input:InputMacro = InputMacro.new()
var velocity:Vector3 = Vector3()
var wanderToPoint:Vector3 = Vector3()

func apply_rotation(delta):
	actor.rotate_y(input.mouse_horizontal)
	actor.trainer.rotation_degrees.y = rad2deg(actor.global_transform.basis.get_euler().y)
	pass

func initialize(args = {}):
	args = .initialize(args)
	Global.InputObserver.clear()
	Global.InputObserver.subscribe(self)
	pass

func parse_input(_input):
	input = _input
	if (input.engage or input.tab) and actor.trainer.can_exit_horse():
		print("TAB PRESSED HORSE")
		Global.InputObserver.unsubscribe(self)
		actor.enter_idle()
		#actor.trainer.exit_pilot(false)

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
		#actor.trainer.exit_pilot()
		#actor.set_state()
	return direction

func run(delta):
	apply_rotation(delta)
	var direction = parse_movement(actor, delta)
	update_animation(direction)
	var movement = actor.move_at_speed({"dir":direction, "velocity":velocity, "delta":delta, "jump":input.space})
	velocity = movement.velocity
#	if movement.position.distance_to(wanderToPoint) < 4:
#		actor.get_state_machine().set_behaivor("Idle")
	pass

func update_animation(direction):
	if actor.get_animation_controller() != null:
		if direction.z != 0:
			actor.get_animation_controller().play_animation("Trot")
		elif direction.x != 0:
			actor.get_animation_controller().play_animation("Walk")
		else:
			actor.get_animation_controller().play_animation("Idle")
	pass
