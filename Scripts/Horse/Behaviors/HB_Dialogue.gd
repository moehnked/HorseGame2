extends "res://Scripts/Horse/Behaviors/HorseBehavior.gd"

const RSG = preload("res://Scripts/Statics/RSG.gd")

export(Resource) var dialogueScreenRes

var callback:String = ""
var callbackKargs = {}
var talkingToController = null
var velocity:Vector3 = Vector3()

#func create_dialogue(controller):
func create_dialogue(args):
	#var o = load("res://prefabs/UI/Dialogue/DialogueScreen.tscn").instance()
	var o = dialogueScreenRes.instance()
	add_child(o)
	#actor.begin_dialogue(controller)
	talkingToController.begin_dialogue(args.actor)
	o.initialize({'speaker':args.actor, 'text':RSG.generate_sentance(), 'listener':talkingToController.get_parent(), 'relationship':args.relationship})

func exit():
	#print("exiting horse state dialogue")
	pass

func initialize(args = {}):
	args = .initialize(args)
	var anim = actor.get_animation_controller()
	anim.set_playback_speed(1.0)
	anim.play_animation("Idle")
	if args.callback != "":
		callback = args.callback
		callbackKargs = args.kargs
	if args.talkingToController != null:
		talkingToController = args.talkingToController
		create_dialogue(args)
		pass
	pass

func run(delta):
	actor.rotate_towards_point(talkingToController.get_parent().global_transform.origin, 0.02)
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
