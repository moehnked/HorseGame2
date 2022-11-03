extends Node

var actor = null
var initialArgs = {}
var stateMachine = null

export var stateName = "Idle"

func _ready():
	add_to_group("Persist")
	pass

func exit_state(exitMethodName):
	if initialArgs["callback"] != "":
		actor.call(initialArgs["callback"], initialArgs["kargs"])
	else:
		call(exitMethodName)

func initialize(args = {}):
	args = Utils.check(args, {"actor":actor, "stateMachine":get_parent(), "callback":"", "kargs":{},"talkingToController":null})
	set_init_args(args)
	actor = args.actor
	stateMachine = args.stateMachine
	return args

func save():
	return Utils.serialize_node(self, {"actor": actor.get_uid() if actor != null else null})

func set(param, val):
	match param:
		"actor":
			pass
		"stateMachine":
			pass
		_:
			.set(param, val)

func set_init_args(args = {}):
	if args.keys().has("initialArgs"):
		initialArgs = args.initalArgs
	else:
		initialArgs = args
	pass
