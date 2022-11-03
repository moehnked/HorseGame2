extends "res://Scripts/Behavior/BehaviorState.gd"

var actor
var ac

func initialize(args = {}):
	.initialize(args)
	actor = initArgs["actor"]
	ac = actor.get_animation_controller()
	ac.play("Idle")

