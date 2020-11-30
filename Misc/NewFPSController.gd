extends KinematicBody

var airAcceleration = 1
var direction = Vector3()
var fullContact = false
var gravity = 20
var gravityVector = Vector3()
var hAcceleration = 6
var hVelocity = Vector3()
var jump = 10
var mouseSensitivity = 0.09
var movement = Vector3()
var normalAcceleration = 6
export var speed = 1

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass # Replace with function body.

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouseSensitivity))
		$Head.rotate_x(deg2rad(-event.relative.y * mouseSensitivity))
		$Head.rotation.x = clamp($Head.rotation.x, deg2rad(-89), deg2rad(89))

func _physics_process(delta):
	direction = Vector3()
	
	if $GroundCheck.is_colliding():
		fullContact = true
	else:
		fullContact = false
	
	if not is_on_floor():
		gravityVector += Vector3.DOWN * gravity * delta
		hAcceleration = airAcceleration
	elif is_on_floor() and fullContact:
		gravityVector = - get_floor_normal() * gravity
		hAcceleration = normalAcceleration
	else:
		gravityVector = - get_floor_normal()
		hAcceleration = normalAcceleration
	
	if Input.is_action_just_pressed("jump") and (is_on_floor() or $GroundCheck.is_colliding()):
		gravityVector = Vector3.UP * jump
	
	if Input.is_action_pressed("move_forward"):
		direction -= transform.basis.z
	if Input.is_action_pressed("move_backward"):
		direction += transform.basis.z
	if Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
	if Input.is_action_pressed("move_right"):
		direction += transform.basis.x
	
	direction = direction.normalized()
	hVelocity = hVelocity.linear_interpolate(direction * speed, hAcceleration * delta)
	movement.z = hVelocity.z + gravityVector.z
	movement.x = hVelocity.x + gravityVector.x
	movement.y = gravityVector.y
	move_and_slide(movement, Vector3.UP)
