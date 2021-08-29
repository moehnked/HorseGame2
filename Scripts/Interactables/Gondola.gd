extends Spatial

var currentPoint = Vector3()
export(NodePath) var nextPointRef
var nextPoint = Vector3()
export var stopThresh = 0.01
export var speed = 0.01
var level = 0

enum State {IDLE, MOVING}
var state = State.IDLE

var liftObservers = []

# Called when the node enters the scene tree for the first time.
func _ready():
	currentPoint = global_transform.origin
	nextPoint = get_node(nextPointRef).global_transform.origin
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match state:
		State.MOVING:
			moving(delta)

func moving(delta):
	var dir = global_transform.origin.direction_to(global_transform.origin.linear_interpolate(nextPoint, 0.5))
	dir = dir * speed * delta
	global_transform.origin += dir
	#global_transform.origin = global_transform.origin.linear_interpolate(np, 0.3 * delta)
	for o in liftObservers:
		print(o.name)
		o.global_transform.origin += dir
	if global_transform.origin.distance_to(nextPoint) < stopThresh:
		level = 0 if level != 0 else 1
		state = State.IDLE
		$Door_Generic.canOpen = true
		nextPoint = currentPoint
		currentPoint = get_node(nextPointRef).global_transform.origin
	pass


func _on_RemoteButton_emit_prompt(_prompt):
	_prompt.prompt = "Ascend" if level == 0 else "Descend"
	$Door_Generic.canOpen = false
	pass # Replace with function body.


func _on_RemoteButton_interaction(controller):
	if state == State.IDLE:
		state = State.MOVING
	$Door_Generic.close()
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
