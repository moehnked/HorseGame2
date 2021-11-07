extends Spatial

onready var rootRef = get_tree().get_root().get_node("World")
onready var Utils = preload("res://Utils.gd")

var focus = null
var input = InputMacro.new()
var isRunning = false
var origin = Vector3(0,0,0)
export var speed = 4


func _ready():
	#call_deferred("subscribe_to")
	pass # Replace with function body.

func _physics_process(delta):
	if isRunning:
		rotate_x(input.mouse_vertical)
		rotation.x = clamp(rotation.x, deg2rad(-60), deg2rad(60))

func _process(delta):
	if is_focused():
		rotation_degrees.x = interpolation(rotation_degrees.x,rad2deg(atan2(((focus.global_transform.origin.y + 2) - global_transform.origin.y), (Vector2(global_transform.origin.x, global_transform.origin.z).distance_to(Vector2(focus.global_transform.origin.x, focus.global_transform.origin.z))))), delta*speed)
		owner.global_transform = owner.global_transform.interpolate_with(owner.global_transform.looking_at(focus.global_transform.origin, Vector3.UP), 0.1)
		owner.correct_scale()
		owner.rotation_degrees.x = 0
		owner.rotation_degrees.z = 0

func interpolation(from, to, t):
	return from * (1 - t) + to * t

func is_focused():
	return focus != null

func look_at_object(object):
	print("looking at ", object.name)
	focus = object
	unsubscribe_to()

func set_mask(color):
	$Camera/Area/Mask.get_surface_material(0).albedo_color = color

func subscribe_to():
	Global.InputObserver.subscribe(self)
	Utils.capture_mouse()
	isRunning = true

func unfocus():
	subscribe_to()
	focus = null
	#rotation_degrees = origin

func unsubscribe_to():
	input = InputMacro.new()
	Global.InputObserver.unsubscribe(self)
	isRunning = false
	
func parse_input(_input):
	input = _input

func stop():
	input = InputMacro.new()
