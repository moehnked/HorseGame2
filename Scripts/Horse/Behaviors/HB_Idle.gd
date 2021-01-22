extends Node

var actor = null
var stateMachine = null

func exit():
	$Timer.stop()
	pass

func initialize(args = {}):
	args = Utils.check(args, {"actor":actor, "stateMachine":get_parent()})
	actor = args.actor
	stateMachine = args.stateMachine
	var anim = actor.get_animation_controller()
	anim.set_playback_speed(1.0)
	anim.play_animation("Idle")
	$Timer.start(Global.world.rng.randi_range(1,5))
	pass

func run(delta):
	#Wait some seconds
	pass


func _on_Timer_timeout():
	#determine if wandering or waiting again
	var i = Global.world.rng.randf()
	if i > 0.5:
		#wander
		stateMachine.set_behavior({"behaviorName":"Wander"})
		return
	stateMachine.set_behavior({"behaviorName":"Idle"})
	pass # Replace with function body.
