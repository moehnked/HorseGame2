extends "res://Scripts/Behavior/BehaviorState.gd"

class_name HorseState_Talking
var actor


func run_state(actor, delta):
	pass

func initialize(args = {}):
	args = Utils.check(args, {"method":"enter_talk_state"})
	actor = args.actor
	call(args.method)
	pass

func enter_talk_state():
	actor.stop_all_timers()
	actor.stop_walking()
	actor.turn_and_face(actor.followingTarget)
	actor.previousInteractionResult = actor.get_interaction_controller().determine_interaction(actor.followingTarget)
#	$TalkCooldownTimer.start(2)
	actor.start_timer_talk_cooldown(2)

func start_conversation():
	actor.stop_walking()
	actor.get_interaction_controller().determine_interaction(actor.followingTarget)
	actor.start_timer_talk_cooldown(2)
