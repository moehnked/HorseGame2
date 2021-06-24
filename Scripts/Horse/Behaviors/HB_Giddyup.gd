extends "res://Scripts/Horse/Behaviors/HorseBehavior.gd"


func initialize(args = {}):
	args = .initialize(args)
	var anim = actor.get_animation_controller()
	var lassoer = args["lasso"].playerRef
	var hat = lassoer.get_hat()
	print("---")
	print(actor.stats.values().max())
	if hat.get_level() >= actor.stats.values().max():
		print("high enough level to LASSO !!!!!!!!!!!!!")
		var challenge = load("res://giddyup_challenge.tscn").instance()
		anim.set_playback_speed(1.0)
		anim.play_animation("Idle")
		#check if we can try
		challenge.initialize({"horse_ref":actor, "callback":"tame"})
		Global.world.call_deferred("add_child", challenge)
		args["lasso"].lassoSucceeded = true
	else:
		print("not high enough level")
		#lassoer.exit_pilot(false)
		print("LASSO FAILED")
	pass

func run(delta):
	#Wait some seconds
	#print("HORSE GIDDYUP")
	pass
