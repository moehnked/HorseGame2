extends "res://Scripts/Behavior/BehaviorState.gd"

var actor

func initialize(args = {}):
	args = Utils.check(args, {"actor":null})
	actor = args.actor
	Global.InputObserver.subscribe(self)
	actor.start_timer_exit_horse()
	actor.toggle_all_collisions(true)
	actor.unsubscribe_to()

func parse_input(input):
	if(input.engage):
		Global.InputObserver.unsubscribe(self)
		actor.exit_pilot(true)
