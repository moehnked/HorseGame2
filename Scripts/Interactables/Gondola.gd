extends Spatial

export(NodePath) var pointA = null
export(NodePath) var pointB = null
export var stopThresh = 0.01
export var speed = 0.01

var global_dir
var level = 0
var liftObservers = []
var local_dir
var nextPoint

enum State {IDLE, MOVING, INIT}
var state = State.INIT



signal door_state_change(door)

# Called when the node enters the scene tree for the first time.
func _ready():
	nextPoint = get_node(pointB)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	match state:
		State.MOVING:
			moving(delta)
		State.INIT:
			initialize()

func calculate_direction_to_next_point():
	local_dir = transform.origin.direction_to(nextPoint.transform.origin)
	global_dir = global_transform.origin.direction_to(nextPoint.global_transform.origin)

func check_distance():
	var next
	if transform.origin.distance_to(nextPoint.transform.origin) < stopThresh:
		level = 0 if level != 0 else 1
		state = State.IDLE
		$Door_Generic.canOpen = true
		update_next_point(pointA)
	pass

func get_direction_to_next_point():
	return transform.origin.direction_to(nextPoint)

func initialize():
	if pointA == null:
		var starting_point = Utils.create_spatial_at(transform.origin)
		get_parent().add_child(starting_point)
		starting_point.transform.origin = transform.origin
		pointA = starting_point.get_path()
	state = State.IDLE

func moving(delta):
	calculate_direction_to_next_point()
	print(global_dir)
	print(local_dir)
	var vel = local_dir * speed * delta
	transform.origin += vel
	move_observers(global_dir, delta)
	check_distance()
	pass

func move_observers(vel, delta):
	#var gpoint = get_node(nextPointRef).global_transform.origin
	var gvel = vel * speed * delta
	for o in liftObservers:
		o.global_transform.origin += gvel
		pass

func update_next_point(point_path):
	pointA = pointB
	pointB = point_path
	nextPoint = get_node(pointB)

func _on_RemoteButton_emit_prompt(_prompt):
	_prompt.prompt = "Ascend" if level == 0 else "Descend"
	pass # Replace with function body.


func _on_RemoteButton_interaction(controller):
	if state == State.IDLE:
		state = State.MOVING
	$Door_Generic.close()
	$Door_Generic.canOpen = false
	pass # Replace with function body.


func _on_Area_body_entered(body):
	print("gondola: ", body.name)
	if body.is_in_group("Liftable"):
		if not liftObservers.has(body):
			liftObservers.append(body)
	pass # Replace with function body.


func _on_Area_body_exited(body):
	print("gondola: ", body.name, " exited")
	if body.is_in_group("Liftable"):
		if liftObservers.has(body):
			liftObservers.erase(body)
	pass # Replace with function body.


func _on_Door_Generic_door_state_changed(door):
	emit_signal("door_state_change", door)
	pass # Replace with function body.
