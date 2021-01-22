extends Node

onready var currentBehavior = $HB_Idle

# Called when the node enters the scene tree for the first time.
func _ready():
	currentBehavior.call_deferred("initialize", {"actor":get_parent(), "stateMachine":self})
	pass # Replace with function body.

func _physics_process(delta):
	currentBehavior.run(delta)

func get_state():
	return currentBehavior.name.lstrip("HB_")

func set_behavior(args = {}):
	args = Utils.check(args, {"behaviorName":"Idle", "callback":"", "kargs":{}})
	if currentBehavior.has_method("exit"):
		currentBehavior.exit()
	var next = get_node("HB_" + args.behaviorName)
	if next != null:
		currentBehavior = next
	currentBehavior.initialize({"actor":get_parent(), "stateMachine":self, "callback":args.callback, "kargs":args.kargs})
