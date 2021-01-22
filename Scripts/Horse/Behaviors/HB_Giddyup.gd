extends Node

var actor = null
var stateMachine = null

func initialize(args = {}):
	args = Utils.check(args, {"actor":actor, "stateMachine":get_parent(), "callback":"set_state", "kargs":{"state":"Idle"}})
	actor = args.actor
	stateMachine = args.stateMachine
	var anim = actor.get_animation_controller()
	anim.set_playback_speed(1.0)
	anim.play_animation("Idle")
	var challenge = load("res://giddyup_challenge.tscn").instance()
	challenge.initialize({"horse_ref":actor, "callback":args.callback, "kargs":args.kargs})
	Global.world.call_deferred("add_child", challenge)
	pass

func run(delta):
	#Wait some seconds
	pass
