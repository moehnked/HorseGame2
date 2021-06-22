extends "res://Scripts/Behavior/BehaviorState.gd"

class_name HorseState_Pilot

var actor
var adjustedSpeed:float = 0.0
var direction:Vector3 = Vector3()
var input
var velocity:Vector3 = Vector3()

func run_state(actor, delta):
	input = actor.input
	actor.rotate_y(actor.input.mouse_horizontal)
	parse_movement(actor, delta)
	move_based_on_input(actor, delta)

func initialize(args = {}):
	print("initializing HB pilot")
	actor = args.actor
	actor.stop_all_timers()
	Global.Player.enter_pilot()
	actor.play_random_sound()
	actor.subscribe_to()
	actor.get_interaction_controller().disable_interaction()
	adjustedSpeed = Utils.calculate_adjusted_speed(actor.stats.Speed)

#func calculate_adjusted_speed():
#	return 10 * sqrt(actor.stats.Speed)

func move_based_on_input(actor, delta):
	Global.Player.rotation.y = actor.rotation.y
	Global.Player.global_transform.origin = actor.get_saddle().global_transform.origin
	if(direction.z != 0.0 and actor.currentAnimation != "Trot"):
		actor.set_animation("Trot", clamp(actor.stats.Speed * 0.6, 1.0, 4.0))
	elif (direction.z == 0.0 and actor.currentAnimation != "Idle"):
		actor.set_animation("Idle", clamp(actor.stats.Speed * 0.3, 1.0, 4.0))


func parse_movement(actor, delta):
	direction = Vector3()
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
	
	var h_velocity = velocity
	h_velocity.y = 0
	var movement = direction * adjustedSpeed
	
	var acceleration
	if direction.dot(h_velocity) > 0:
		acceleration = actor.MAX_ACCEL
	else:
		acceleration = actor.DEACCEL
		
	h_velocity = h_velocity.linear_interpolate(movement, acceleration * delta)
	velocity.x = h_velocity.x
	velocity.z = h_velocity.z
	
	if input.space and (actor.has_contact):
		velocity.y = 10
		actor.has_contact = false
	else:
		velocity.y = actor.velocity.y
	
	velocity = actor.move_and_slide(velocity, Vector3.UP)
	actor.velocity = velocity
