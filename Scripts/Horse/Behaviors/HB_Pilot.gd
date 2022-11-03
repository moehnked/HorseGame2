extends "res://Scripts/Horse/Behaviors/HorseBehavior.gd"

var input:InputMacro = InputMacro.new()
var velocity:Vector3 = Vector3()
var wanderToPoint:Vector3 = Vector3()
var firstFrame = true

func apply_rotation(delta):
	actor.rotate_y(input.mouse_horizontal)
	actor.trainer.rotation_degrees.y = rad2deg(actor.global_transform.basis.get_euler().y)
	pass

func initialize(args = {}):
	args = .initialize(args)
	Global.InputObserver.clear()
	Global.InputObserver.subscribe(self)
	velocity = Vector3.ZERO
	pass

func parse_input(_input):
	input = _input
	if input.tab and actor.trainer.can_exit_horse():
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
	if not firstFrame:
		apply_rotation(delta)
		var direction = parse_movement(actor, delta)
		update_animation(direction)
		var movement = actor.move_at_speed({"dir":direction, "velocity":velocity, "delta":delta, "jump":input.space})
		velocity = movement.velocity
	else:
		var movement = actor.move_at_speed({"dir":Vector3(0,1,0), "velocity":Vector3(0,5,0), "delta":delta, "jump":true})
		velocity = movement.velocity
		firstFrame = false
#	if movement.position.distance_to(wanderToPoint) < 4:
#		actor.get_state_machine().set_behaivor("Idle")
	pass

func update_animation(direction):
	var ac = actor.get_animation_controller() 
	if ac != null:
		if direction.z != 0:
			ac.set_playback_speed(0.5)
			ac.play_animation("Trot")
		elif direction.x != 0:
			ac.set_playback_speed(0.8)
			ac.play_animation("Walk")
		else:
			ac.set_playback_speed(1.0)
			ac.play_animation("Idle")
	pass
