extends KinematicBody

export var DEACCEL:int = 6
export var MAX_ACCEL:int = 2
export var MAX_SLOPE_ANGLE:float = 90
export var MAX_SPEED:int= 10

var has_contact:bool = false
var gravity = -20
var trainer = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func can_be_lassod():
	var non_lassoable_state = []
	var state = $StateMachine.get_state()
	return not non_lassoable_state.has(state)

func enter_pilot():
	set_state({"behaviorName":"Pilot"})

func enter_giddyup():
	set_state({"behaviorName":"Giddyup", "callback":"tame"})
	pass

func get_animation_controller():
	return $horse_animated

func get_ground_check():
	return $GroundCheck

func get_saddle():
	return $Saddle

func lasso(lasso):
	print(name, ": 'I'm being lasso'd by", lasso.playerRef.name ,"!'")
	if trainer != null:
		#enter pilot
		pass
	else:
		enter_giddyup()

func move_at_speed(args = {}):
	args = Utils.check(args, {"dir":Vector3(), "speed":10, "velocity":Vector3(), "delta":0.0})
	var delta = args.delta
	var velocity = args.velocity
	var direction = args.dir
	direction.y = 0
	direction = direction.normalized()
	
	if is_on_floor():
		has_contact = true
		var n = get_ground_check().get_collision_normal()
		var floor_angle = rad2deg(acos(n.dot(Vector3.UP)))
		if floor_angle > MAX_SLOPE_ANGLE:
			velocity.y += gravity * delta
	else:
		if not get_ground_check().is_colliding():
			has_contact = false
		velocity.y += gravity * delta
	if has_contact and !is_on_floor():
		#print("pulling down: ", actor.global_transform.origin.y)
		move_and_collide(Vector3(0,-2,0))
	
	var h_velocity = velocity
	h_velocity.y = 0
	var movement = direction * MAX_SPEED
	
	var acceleration
	if direction.dot(h_velocity) > 0:
		acceleration = MAX_ACCEL
	else:
		acceleration = DEACCEL
		
	h_velocity = h_velocity.linear_interpolate(movement, acceleration * delta)
	velocity.x = h_velocity.x
	velocity.z = h_velocity.z
	
	velocity = move_and_slide(velocity, Vector3.UP)
	return {"velocity":velocity, "direction":direction, "position":global_transform.origin}

func rotate_towards_point(point):
	var old_rot = rotation_degrees
	var trs = global_transform.looking_at(point, Vector3.UP)
	global_transform = trs
	rotation_degrees.x = 0
	rotation_degrees.z = 0
	rotation_degrees.y += 180
	old_rot = old_rot.linear_interpolate(rotation_degrees, 0.01)
	rotation_degrees = old_rot

func set_state(args = {}):
	args = Utils.check(args, {"behaviorName":"Idle", "callback":"set_state", "kargs": {}})
	$StateMachine.set_behavior(args)

func tame(args):
	args= Utils.check(args, {"tamer": null})
	trainer = args.tamer
	#pep += 1
	#play_random_whinny()
	if(!trainer.add_to_party(self)):
		print("party full")
		#go_to_corral()
	else:
		#enter_pilot()
		pass
