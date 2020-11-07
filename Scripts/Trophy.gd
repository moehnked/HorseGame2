extends RigidBody

func take_damage(dmg, hitbox, source):
	print("NICE!!! YOU GOT A TROPHY")
	var particles = load("res://prefabs/Effects/TrophyShatter.tscn").instance()
	source.call("add_child", particles)
	particles.global_transform.origin = self.global_transform.origin
	if(source.rootRef != null):
		source.rootRef.play_sound("res://sounds/Trophy_Break_01.wav", -3)
	queue_free()
