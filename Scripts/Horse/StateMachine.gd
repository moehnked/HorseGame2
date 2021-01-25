extends Node

onready var currentBehavior = $HB_Idle
var isRunning:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	currentBehavior.call_deferred("initialize", {"actor":get_parent(), "stateMachine":self, "callback":"set_is_running"})
	pass # Replace with function body.

func _physics_process(delta):
	if isRunning:
		currentBehavior.run(delta)

func get_state():
	return currentBehavior.name.lstrip("HB_")

func set_behavior(args = {}):
	args = Utils.check(args, {"behaviorName":"Idle", "actor":get_parent(), "stateMachine":self})
	if currentBehavior.has_method("exit"):
		currentBehavior.exit()
	var next = get_node("HB_" + args.behaviorName)
	if next != null:
		currentBehavior = next
	currentBehavior.initialize(args)

func set_is_running(state = true):
	isRunning = state
