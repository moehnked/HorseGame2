extends "res://Scripts/Horse/Behaviors/HorseBehavior.gd"

export(Resource) var rpsGameRes
var talkingToController = null

func initialize(args = {}):
	args = .initialize(args)
	var anim = actor.get_animation_controller()
	anim.set_playback_speed(1.0)
	anim.play_animation("RPS_Ready")
	if args.talkingToController != null:
		talkingToController = args.talkingToController
		#create_dialogue(args)
		var o = rpsGameRes.instance()
		Global.world.add_child(o)
		o.initialize({"horseRef": actor, "behaviorRef": self, "spellRef":args["spellRef"]})
		pass
	pass

func create_RPS_interface():
	pass
	

func run(delta):
	actor.rotate_towards_point(talkingToController.get_parent().global_transform.origin, 0.02)
	pass
