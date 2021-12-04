extends RigidBody

export(Resource) var particlesRef


func take_damage(dmg, hitbox, source):
	print("NICE!!! YOU GOT A TROPHY")
	var particles = particlesRef.instance()
	Global.world.call("add_child", particles)
	particles.global_transform.origin = self.global_transform.origin
	#Global.AudioManager.play_sound("res://Sounds/glass_break_0"+ String(Global.world.rng.randi_range(1,5)) +".wav", -3)
	Global.SEM.play_random_bit()
	$PlaySound.trigger()
	queue_free()
