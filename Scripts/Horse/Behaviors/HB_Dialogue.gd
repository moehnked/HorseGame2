extends "res://Scripts/Horse/Behaviors/HorseBehavior.gd"

const RSG = preload("res://Scripts/Statics/RSG.gd")

var callback:String = ""
var callbackKargs = {}
var talkingToController = null
var velocity:Vector3 = Vector3()

func create_dialogue(controller):
	var o = load("res://Scripts/UI/DialogueScreen.tscn").instance()
	add_child(o)
	#actor.begin_dialogue(controller)
	controller.begin_dialogue(actor)
	o.initialize({'speaker':actor, 'text':RSG.generate_sentance(), 'listener':controller.get_parent()})

func exit():
	print("exiting horse state dialogue")
	pass

func initialize(args = {}):
	args = .initialize(args)
	var anim = actor.get_animation_controller()
	anim.set_playback_speed(1.0)
	anim.play_animation("Idle")
	if args.callback != "":
		callback = args.callback
		callbackKargs = args.kargs
	#create dialogue
	if args.talkingToController != null:
		talkingToController = args.talkingToController
		create_dialogue(talkingToController)
		pass
	pass

func run(delta):
	actor.rotate_towards_point(talkingToController.get_parent().global_transform.origin, 0.02)
	#velocity = actor.move_at_speed({"dir":Vector3(), "speed":1, "velocity":velocity, "delta":0.0, "jump":false}).velocity
	#velocity = actor.apply_gravity(velocity, delta)
	#actor.move_and_slide(velocity)
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
