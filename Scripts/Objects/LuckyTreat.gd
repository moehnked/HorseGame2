extends Spatial

export(float) var treats = -1.0

func acquire_treat(x = null):
	Global.Player.treats += treats if treats > 0 else Global.world.rng.randi_range(1,10)
	queue_free()
