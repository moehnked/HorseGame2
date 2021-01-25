extends "res://Scripts/Horse/Behaviors/HorseBehavior.gd"

var velocity:Vector3 = Vector3()

func exit():
	print("exiting horse state idle")
	$Timer.stop()
	pass

func initialize(args = {}):
	args = .initialize(args)
	var anim = actor.get_animation_controller()
	anim.set_playback_speed(1.0)
	anim.play_animation("Idle")
	$Timer.start(Global.world.rng.randi_range(1,5))
	if args.callback != "":
		stateMachine.call(args.callback)
	pass

func run(delta):
	#velocity = actor.move_at_speed({"dir":Vector3(), "speed":1, "velocity":velocity, "delta":0.0, "jump":false}).velocity
	velocity = actor.apply_gravity(velocity, delta)
	actor.move_and_slide(velocity)
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
