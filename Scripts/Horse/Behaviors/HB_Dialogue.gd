extends "res://Scripts/Horse/Behaviors/HorseBehavior.gd"

const RSG = preload("res://Scripts/Statics/RSG.gd")

export(Resource) var dialogueScreenRes

var callback:String = ""
var callbackKargs = {}
var talkingToController = null
var velocity:Vector3 = Vector3()

func create_dialogue(args):
	var o = dialogueScreenRes.instance()
	add_child(o)
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
		#check if relationship and pep are valid for communication
		if actor.has_method("emit_talked_to_npc"):
			actor.call("emit_talked_to_npc")
		var rm = actor.get_relationship_manager()
		if rm.check_if_conversable(args):
			create_dialogue(args)
			actor.call("disable_interaction")
		else:
			Global.InteractionPrompt.show_context(actor.get_horse_name() + " doesn't want to talk to you...")
			Global.AudioManager.play_sound("res://Sounds/horse_noise_05.wav", 0, Utils.get_rng().randf_range(-2,2))
			actor.call("exit_dialogue")
		#else return to state and play sound
		#talkingToController = args.talkingToController
		#create_dialogue(args)
		pass
	pass

func run(delta):
	actor.rotate_towards_point(talkingToController.get_parent().global_transform.origin, 0.02)
	pass
