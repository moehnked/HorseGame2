extends "res://Scripts/Behavior/BehaviorState.gd"

class_name PlayerState_Normal

var direction:Vector3 = Vector3()
var gravity = -20
var hAcceleration = 6
var has_contact:bool = false
var input
var movement:Vector3 = Vector3()
var velocity:Vector3 = Vector3()


func run_state(actor, delta):
	input = actor.input
	update_raycast(actor)
	apply_rotation(actor)
	parse_movement(actor, delta)
	pass

func initialize(args = {}):
	var actor = args.actor
	var head = actor.get_head()
	actor.subscribe_to()
	head.subscribe_to()
	actor.canUpdateHands = true
	actor.canCheckInventory = true
	actor.canResetCasting = true
	actor.queue_spell_clear()
	var ic = actor.get_equipment_manager()
	if ic.equipped == null and not actor.isBuilding:
		print("renablke casting, returning to state: normal - ", actor.isBuilding)
		actor.get_hand().update_hand_sprite("Idle")
		actor.get_hand().set_animation_playback(true)
		actor.enable_casting()

func apply_rotation(actor):
	#if state != State.giddyup and not isBuilding:
	actor.rotate_y(actor.input.mouse_horizontal)

func parse_movement(actor, delta):
	direction = Vector3()
	var aim = actor.get_camera().global_transform.basis
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
	
	if actor.is_on_floor():
		has_contact = true
		var n = actor.get_ground_check().get_collision_normal()
		var floor_angle = rad2deg(acos(n.dot(Vector3.UP)))
		if floor_angle > actor.MAX_SLOPE_ANGLE:
			velocity.y += gravity * delta
	else:
		if not actor.get_ground_check().is_colliding():
			has_contact = false
		velocity.y += gravity * delta
	if has_contact and !actor.is_on_floor():
		#print("pulling down: ", actor.global_transform.origin.y)
		actor.move_and_collide(Vector3(0,-2,0))
	
	var h_velocity = velocity
	h_velocity.y = 0
	var movement = direction * actor.MAX_SPEED
	
	var acceleration
	if direction.dot(h_velocity) > 0:
		acceleration = actor.MAX_ACCEL
	else:
		acceleration = actor.DEACCEL
		
	h_velocity = h_velocity.linear_interpolate(movement, acceleration * delta)
	velocity.x = h_velocity.x
	velocity.z = h_velocity.z
	
	if input.space and (has_contact or actor.isSwimming):
		print("jumping")
		velocity.y = 10
		has_contact = false
	
	velocity = actor.move_and_slide(velocity, Vector3.UP)

func send_raycast_data(raycastobj, actor):
	for placer in actor.placer_observers:
		placer.parse_raycast(raycastobj, actor.global_transform.origin)

func update_raycast(actor):
	var raycastobj = actor.get_solid_raycast()
	if raycastobj.is_colliding():
		send_raycast_data(raycastobj, actor)
		for o in actor.raycastObservers:
			o.parse_raycast(raycastobj)
	else:
		for o in actor.raycastObservers:
			o.clear_raycast()
