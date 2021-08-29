extends "res://Scripts/Behavior/BehaviorState.gd"

var actor
var canExitHorse = false

func enable_exit_pilot():
	print("can exit horse")
	canExitHorse = true

func initialize(args = {}):
	print("initializing player pilot state")
	args = Utils.check(args, {"actor":null})
	actor = args.actor
	print("actor has saddle? - ", (actor.saddle != null))
	Global.InputObserver.subscribe(self)
	actor.toggle_all_collisions(true)
	actor.unsubscribe_to()
	Global.world.queue_timer(self, 0.2, "enable_exit_pilot")
	actor.get_head().subscribe_to()

func parse_input(input):
	if input.tab:
		print("exit")
		unsubscribe_to()
	#actor.rotate_y(input.mouse_horizontal)

func run_state(actor, delta):
	#actor.global_transform.origin = actor.saddle.global_transform.origin
	#actor.rotation_degrees.y = actor.saddle.get_parent().rotation_degrees.y
	pass

func unsubscribe_to():
	Global.InputObserver.unsubscribe(self)
