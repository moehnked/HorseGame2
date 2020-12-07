extends RigidBody

func take_damage(dmg, hitbox, source):
	print("NICE!!! YOU GOT A TROPHY")
	var particles = load("res://prefabs/Effects/TrophyShatter.tscn").instance()
	Global.world.call("add_child", particles)
	particles.global_transform.origin = self.global_transform.origin
	Global.AudioManager.play_sound("res://sounds/Trophy_Break_01.wav", -3)
	queue_free()
