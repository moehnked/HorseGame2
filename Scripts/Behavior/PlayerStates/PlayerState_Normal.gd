extends "res://Scripts/Behavior/BehaviorState.gd"

class_name PlayerState_Normal

var direction:Vector3 = Vector3()
var gravity = -20
var hAcceleration = 6
var has_contact:bool = false
var input
var isSliding = false
var movement:Vector3 = Vector3()
var velocity:Vector3 = Vector3()
var snapVector = Vector3(0,0,0)

var dustEffect = preload("res://prefabs/Effects/Sliding.tscn")
var lasSpawnedDustParticle


func run_state(actor, delta):
	input = actor.input
	update_raycast(actor)
	apply_rotation(actor)
	parse_movement(actor, delta)
	pass

func initialize(args = {}):
	print("PB: Normal: initializing")
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
	actor.rotate_y(actor.input.mouse_horizontal)

func parse_movement(actor, delta):
	isSliding = false
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
	
	snapVector = Vector3.ZERO
	var n = null
	if actor.get_slide_count() >= 1:
		n = actor.get_slide_collision(0)
	var floor_angle = 0
	if n != null:
		floor_angle = rad2deg(n.normal.angle_to(Vector3.UP))
		if floor_angle > actor.MAX_SLOPE_ANGLE:
			#print("xwa")
			velocity.y += gravity * delta
			if n.collider.is_in_group("Ground"):
				print("sliding")
				isSliding = true
		else:
			#print("xwb")
			has_contact = true
			snapVector = -n.normal
	elif not actor.get_ground_check().is_colliding():
		has_contact = false
		velocity.y += gravity * delta
	elif actor.is_on_floor():
		#print("xwD")
		has_contact = true
	else:
		#print("xwE")
		has_contact = true
		var raynormal = actor.get_ground_check().get_collision_normal()
		floor_angle = rad2deg(raynormal.angle_to(Vector3.UP))
	
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
		actor.random_grunt()

	velocity = actor.move_and_slide_with_snap(velocity, snapVector ,Vector3.UP, true, 1, actor.MAX_SLOPE_ANGLE, false)


func send_raycast_data(raycastobj, actor):
	for placer in actor.placer_observers:
		placer.parse_raycast(raycastobj, actor.global_transform.origin)

func spawn_dust():
	lasSpawnedDustParticle = dustEffect.instance()
	Global.world.add_child(lasSpawnedDustParticle)
	lasSpawnedDustParticle.global_transform.origin = Global.Player.global_transform.origin

func update_raycast(actor):
	var raycastobj = actor.get_solid_raycast()
	if raycastobj.is_colliding():
		send_raycast_data(raycastobj, actor)
		for o in actor.raycastObservers:
			o.parse_raycast(raycastobj)
	else:
		for o in actor.raycastObservers:
			o.clear_raycast()


func _on_SlidingTimer_timeout():
	if isSliding and not Global.Player.isSwimming:
		if lasSpawnedDustParticle != null:
			if lasSpawnedDustParticle.global_transform.origin.distance_to(Global.Player.global_transform.origin) > 5:
				spawn_dust()
			else:
				return
		else:
			spawn_dust()
		pass
	pass # Replace with function body.
