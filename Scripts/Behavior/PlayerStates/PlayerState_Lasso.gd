extends "res://Scripts/Behavior/BehaviorState.gd"

class_name PlayerState_Lasso

var actor

func run_state(actor, delta):
	self.actor = actor
	move_towards(actor.saddle, delta)
	pass

func add_to_party(member):
	actor.add_to_party(member)

func enter_giddyup(target):
	print("player enter_giddyup")
	actor.stop_lasso_timer()
	actor.global_transform = target.global_transform
	actor.correct_scale()
	actor.set_behavior("Giddyup")
	actor.disable_collisions()

func enter_pilot(target):
	enter_giddyup(target)
	actor.set_behavior("Pilot")

func move_towards(target, delta):
	var opposite = target.global_transform.origin.x - actor.global_transform.origin.x
	var adjacent = target.global_transform.origin.z - actor.global_transform.origin.z
	var angle = atan2(opposite, adjacent)
	actor.rotation_degrees.y = rad2deg(angle) - 180
	var facing = -actor.global_transform.basis.z * actor.MAX_SPEED * 200 * delta
	actor.move_and_slide(facing)
	if(actor.global_transform.origin.distance_to(target.global_transform.origin) < 5):
		if actor.get_party().has(target.owner):
			enter_pilot(target)
		else:
			enter_giddyup(target)
