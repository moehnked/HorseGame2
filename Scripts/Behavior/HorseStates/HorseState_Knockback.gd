extends "res://Scripts/Behavior/BehaviorState.gd"

class_name HorseState_Knockback

var knockbackDirection:Vector3 = Vector3()

func run_state(actor, delta):
	move_based_on_knockback(actor, delta)
	pass
	

func initialize(args = {}):
	args = Utils.check(args, {})
	knockbackDirection = args.vector
	knockbackDirection.y = knockbackDirection.y * 0.5
	args.actor.start_knockback_timer(0.2 * args.dmg)

func move_based_on_knockback(actor, delta):
	actor.move_and_slide(knockbackDirection, Vector3.UP)
	actor.apply_gravity(delta)
