extends "res://Scripts/Behavior/BehaviorState.gd"

class_name HorseState_Giddyup

onready var challengeResource = preload("res://giddyup_challenge.tscn")

var actor

func initialize(args = {}):
	args = Utils.check(args, {"rider": null})
	var rider = args.rider
	actor = args.actor
	actor.stop_all_timers()
	actor.get_interaction_controller().disable_interaction()
	if(actor.has_trainer()):
		actor.enter_pilot()
		rider.enter_pilot()
	else:
		var challenge_instance = challengeResource.instance()
		challenge_instance.horse_ref = actor
		Global.world.call_deferred("add_child", challenge_instance)
