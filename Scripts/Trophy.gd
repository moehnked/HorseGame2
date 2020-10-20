extends RigidBody

func take_damage(dmg, hitbox, player):
	print("NICE!!! YOU GOT A TROPHY")
	var particles = load("res://prefabs/Effects/TrophyShatter.tscn").instance()
	particles.global_transform.origin = self.global_transform.origin
	player.rootRef.call("add_child", particles)
	player.rootRef.play_sound("res://sounds/Trophy_Break_01.wav", -3)
	queue_free()
