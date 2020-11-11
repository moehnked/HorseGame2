extends Spatial

onready var rootRef = get_tree().get_root().get_node("World")
onready var Utils = preload("res://Utils.gd")

export var speed = 4

var origin = Vector3(0,0,0)
var focus = null

func _ready():
	subscribe_to()
	pass # Replace with function body.

func _process(delta):
	if(focus != null):
		rotation_degrees.x = interpolation(rotation_degrees.x,rad2deg(atan2(((focus.global_transform.origin.y + 2) - global_transform.origin.y), (Vector2(global_transform.origin.x, global_transform.origin.z).distance_to(Vector2(focus.global_transform.origin.x, focus.global_transform.origin.z))))), delta*speed)
		owner.global_transform = owner.global_transform.interpolate_with(owner.global_transform.looking_at(focus.global_transform.origin, Vector3.UP), 0.1)
		owner.rotation_degrees.x = 0
		owner.rotation_degrees.z = 0

func interpolation(from, to, t):
	return from * (1 - t) + to * t

func look_at_object(object):
	print("looking at ", object.name, " --> ", object.global_transform.basis)
	focus = object
	unsubscribe_to()

func subscribe_to():
	rootRef.get_node("InputObserver").subscribe(self)
	Utils.capture_mouse()

func unfocus():
	subscribe_to()
	focus = null
	#rotation_degrees = origin

func unsubscribe_to():
	rootRef.get_node("InputObserver").unsubscribe(self)
	
func parse_input(input):
	rotate_x(input.mouse_vertical)
	rotation.x = clamp(rotation.x, deg2rad(-90), deg2rad(90))
