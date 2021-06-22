extends "res://Scripts/Behavior/BehaviorState.gd"

class_name PlayerState_Menu

var actor

func initialize(args = {}):
	actor = args.actor
	actor.unsubscribe_to()
	var head = actor.get_head()
	head.unsubscribe_to()
	actor.canUpdateHands = false
	actor.canCheckInventory = false
	actor.revoke_casting()
	actor.canResetCasting = false
	actor.stop_cast_reset()
