extends "res://Scripts/Horse/Behaviors/HorseBehavior.gd"


func initialize(args = {}):
	args = .initialize(args)
	var anim = actor.get_animation_controller()
	anim.set_playback_speed(1.0)
	anim.play_animation("Idle")
	var challenge = load("res://giddyup_challenge.tscn").instance()
	challenge.initialize({"horse_ref":actor, "callback":"tame"})
	Global.world.call_deferred("add_child", challenge)
	pass

func run(delta):
	#Wait some seconds
	pass
