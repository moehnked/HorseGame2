extends KinematicBody

export var DEACCEL = 6
export var MAX_SPEED = 40
export var MAX_ACCEL = 2
export var MAX_SLOPE_ANGLE = 90

var camera_angle = 0
var camera_change = Vector2()
var direction = Vector3()
var has_contact = false

var mouse_sensitivity = 0.3
var velocity = Vector3()

var gravity = -20

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass # Replace with function body.

func _physics_process(delta):
	walk(delta)
	aim()

func walk(delta):
	direction = Vector3()
	var aim = $Head/Camera.global_transform.basis
	if Input.is_action_pressed("move_forward"):
		direction -= aim.z
	if Input.is_action_pressed("move_backward"):
		direction += aim.z
	if Input.is_action_pressed("move_left"):
		direction -= aim.x
	if Input.is_action_pressed("move_right"):
		direction += aim.x
	direction.y = 0
	direction = direction.normalized()
	
	if is_on_floor():
		has_contact = true
		var n = $RayCast.get_collision_normal()
		var floor_angle = rad2deg(acos(n.dot(Vector3.UP)))
		if floor_angle > MAX_SLOPE_ANGLE:
			velocity.y += gravity * delta
	else:
		if not $RayCast.is_colliding():
			has_contact = false
		velocity.y += gravity * delta
	if has_contact and !is_on_floor():
		move_and_collide(Vector3(0,-1,0))
	
	
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
	
	if Input.is_action_just_pressed("jump") and has_contact:
		velocity.y = 10
		has_contact = false
	
	velocity = move_and_slide(velocity, Vector3.UP, true)

func _input(event):
	if event is InputEventMouseMotion:
		camera_change = event.relative

func aim():
	if(camera_change.length() > 0):
		$Head.rotate_y(deg2rad(-camera_change.x * mouse_sensitivity))
		$Head/Camera.rotate_x(deg2rad(clamp(-camera_change.y * mouse_sensitivity, -90, 90)))
		camera_change = Vector2()
