extends "res://Scripts/Horse/Behaviors/HorseBehavior.gd"

var velocity:Vector3 = Vector3()
export(bool) var isStaticIdle = false

func exit():
	print("exiting horse state idle")
	$Timer.stop()
	pass

func initialize(args = {}):
	args = .initialize(args)
	var anim = actor.get_animation_controller()
	if anim != null:
		anim.set_playback_speed(1.0)
		anim.play_animation("Idle")
	if not isStaticIdle:
		#$Timer.start(Global.world.rng.randi_range(1,5))
		pass
	if args.callback != "":
		if stateMachine.has_method(args.callback):
			stateMachine.call(args.callback)
	pass

func run(delta):
	#velocity = actor.move_at_speed({"dir":Vector3(), "speed":1, "velocity":velocity, "delta":0.0, "jump":false}).velocity
	velocity = actor.apply_gravity(velocity, delta)
	actor.move_and_slide_with_snap(velocity, Vector3.ZERO ,Vector3.UP, true, 1, 0.785398, false)
	#Wait some seconds
	pass


func _on_Timer_timeout():
	#determine if wandering or waiting again
	var i = Global.world.rng.randf()
	if i > 0.5:
		#check if equipment has behavior and maybe do that
		var eq = null
		eq = actor.get_equipment_manager().get_equipped()
		if eq != null:
			var hb = null
			hb = eq.get_behavior()
			if hb != null:
				i = Global.world.rng.randf()
				if i > 0.5:
					stateMachine.set_behavior({"behaviorName":hb.stateName})
				else:
					stateMachine.set_behavior({"behaviorName":"Wander"})
				return
		#wander
		stateMachine.set_behavior({"behaviorName":"Wander"})
		return
	stateMachine.set_behavior({"behaviorName":"Idle"})
	pass # Replace with function body.
