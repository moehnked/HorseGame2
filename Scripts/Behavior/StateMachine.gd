extends KinematicBody

export(NodePath) var initialBehavior

var currentBehavior
var isRunning:bool = false

func _physics_process(delta):
	if isRunning:
		currentBehavior.run()
	
# Called when the node enters the scene tree for the first time.
func _ready():
	currentBehavior = get_node(initialBehavior)
	call_deferred("set_behavior", {"callback":"set_is_running"})
	pass # Replace with function body.

func get_state():
	return currentBehavior.name

func set_behavior(args = {}):
	args = Utils.check(args, {"behaviorName":get_node(initialBehavior).name, "behaviorExit": true, "actor": self})
	if currentBehavior.has_method("exit") and args.behaviorExit:
		currentBehavior.exit()
	var next = get_node(args.behaviorName)
	if next != null:
		currentBehavior = next
	currentBehavior.initialize(args)

func set_is_running(state = true):
	isRunning = state
