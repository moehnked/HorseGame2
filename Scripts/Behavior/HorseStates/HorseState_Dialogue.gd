extends "res://Scripts/Behavior/BehaviorState.gd"

class_name HorseState_Dialogue

var actor

func initialize(args = {}):
	args = Utils.check(args, {"other": Global.world})
	actor = args.actor
	actor.stop_all_timers()
	actor.turn_and_face(args.other)
	actor.set_animation("Idle")
