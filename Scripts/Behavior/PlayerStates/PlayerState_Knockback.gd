extends "res://Scripts/Behavior/BehaviorState.gd"

class_name PlayerState_Knockback
var actor
var knockbackDirection:Vector3 = Vector3()

func run_state(actor, delta):
	move_based_on_knockback(actor, delta)

func initialize(args = {}):
	args = Utils.check(args, {"actor": null, "vector": Vector3(), "dmg": 1})
	actor = args.actor
	actor.revoke_casting()
	actor.revoke_menu_options()
	actor.unsubscribe_to()
	var head = actor.get_head()
	head.unsubscribe_to()
	knockbackDirection = args.vector
	actor.set_knockback_timer(0.2 * args.dmg)
	

func apply_gravity(actor, delta):
	if not actor.is_on_floor():
		actor.move_and_slide(actor.fall, Vector3.UP)

func move_based_on_knockback(actor, delta):
	actor.move_and_slide(knockbackDirection, Vector3.UP)
	apply_gravity(actor, delta)
