extends "res://Scripts/Behavior/BehaviorState.gd"

class_name PlayerState_Knockback

func run_state(actor, delta):
	move_based_on_knockback(actor, delta)

func apply_gravity(actor, delta):
	if not actor.is_on_floor():
		actor.move_and_slide(actor.fall, Vector3.UP)

func move_based_on_knockback(actor, delta):
	actor.move_and_slide(actor.knockbackDirection, Vector3.UP)
	apply_gravity(actor, delta)
