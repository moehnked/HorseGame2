extends RayCast

var velocity = 0.0
var offset = Vector3()
export var DEACCEL = 6
export var MAX_SPEED = 40
export var MAX_ACCEL = 2
export var MAX_SLOPE_ANGLE = 90

var jumping = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.PlayerRaycastVert = self
	Global.InputObserver.subscribe(self)
	offset = Vector3(0,(2.5+cast_to.y) * Global.Player.scaleMod,0)
	pass # Replace with function body.

func jump():
	if not jumping:
		print("jump called")
		velocity = 0.4 * cast_to.y
		global_transform.origin.y += 0.5 * -cast_to.y
		enabled = false
		jumping = true
	pass

func parse_input(input):
	if input.space:
		jump()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_transform.origin.x = Global.Player.global_transform.origin.x
	global_transform.origin.z = Global.Player.global_transform.origin.z
	if(is_colliding()):
		jumping = false
		velocity = 0
		global_transform.origin.y = global_transform.origin.linear_interpolate(to_global(to_local(get_collision_point()) + Vector3(0,-cast_to.y,0)), 0.1).y
		#offset = Vector3(0,(2.5+cast_to.y) * Global.Player.scalemod,0)
		update_player_pos()
	else:
		velocity += 0.02
		global_transform.origin.y -= velocity
		pass
	if jumping:
		update_player_pos()
		if velocity > 0:
			enabled = true
		

func update_player_pos():
	Global.Player.global_transform.origin.y = Global.Player.to_global(Global.Player.to_local(global_transform.origin) + offset).y
	
	
#	pass
