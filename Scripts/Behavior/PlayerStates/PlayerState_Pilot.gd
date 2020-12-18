extends "res://Scripts/Behavior/BehaviorState.gd"

var actor
var canExitHorse = false

func initialize(args = {}):
	args = Utils.check(args, {"actor":null})
	actor = args.actor
	Global.InputObserver.subscribe(self)
	actor.toggle_all_collisions(true)
	actor.unsubscribe_to()
	Global.world.queue_timer(self, 0.2, "enable_exit_pilot")

func enable_exit_pilot():
	canExitHorse = true

func parse_input(input):
	if(input.engage and canExitHorse):
		Global.InputObserver.unsubscribe(self)
		actor.exit_pilot(true)
