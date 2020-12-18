extends "res://Scripts/Behavior/BehaviorState.gd"

class_name HorseState_Idle
var shouldFollowTrainer
var actor

func run_state(actor, delta):
	#apply_gravity(delta)
	move_based_on_gravity(actor, delta)
	if(actor.has_trainer() and shouldFollowTrainer):
		actor.look_for({
			'target':actor.get_trainer(), 
			'r':actor.followThreshold, 
			'callback':"start_moving_towards", 
			'kargs':{'target': actor.get_trainer(), 'thresh': 5, 'callback':"enter_idle_state"}})
		pass
	else:
		actor.find_horse_to_talk_to()
	pass

func initialize(args = {}):
	args = Utils.check(args, {"shouldFollowTrainer": true})
	shouldFollowTrainer = args.shouldFollowTrainer
	actor = args.actor
	actor.start_idle_timer()
	actor.set_animation("Idle")
	actor.velocity.x = 0
	actor.velocity.z = 0

func move_based_on_gravity(actor, delta):
	actor.velocity = actor.move_and_slide(actor.velocity, Vector3.UP)
