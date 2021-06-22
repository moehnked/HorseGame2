extends Node

var actor = null
var initialArgs = {}
var stateMachine = null

export var stateName = "Idle"

func initialize(args = {}):
	args = Utils.check(args, {"actor":actor, "stateMachine":get_parent(), "callback":"", "kargs":{},"talkingToController":null})
	set_init_args(args)
	actor = args.actor
	stateMachine = args.stateMachine
	return args

func set_init_args(args = {}):
	if args.keys().has("initialArgs"):
		initialArgs = args.initalArgs
	else:
		initialArgs = args
	pass
