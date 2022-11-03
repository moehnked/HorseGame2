extends Node

class_name BehaviorState

var initArgs = {}

func run_state(actor, delta):
	pass

func run():
	pass

func initialize(args = {}):
	args = Utils.check(args, {})
	initArgs = args

