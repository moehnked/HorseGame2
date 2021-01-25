extends "res://Scripts/Items/Handaxe.gd"


func check_if_body_valid(body):
	var c = true
	if controller != null:
		c = body != controller.get_parent()
	return (body != self and c)

func chop(body):
	var par = 1 if Global.world.rng.randf() > 0.5 else -1
	var v =  Vector3(Global.world.rng.randf() * par,Global.world.rng.randf() * -par,Global.world.rng.randf() * par) * 30
	print("collided! : ", body.name)
	angular_velocity = v
	check_collision(body)

func collision_effect(other):
	print("axe hit ", other, ", ", other.name)
	isRetracting = true
	canChop = false
	$ChopTimer.start()
	other.call_deferred("deconstruct")

func _on_Mallet_body_entered(body):
	if check_if_body_valid(body):
		var path = "res://Sounds/axe_hit_01.wav"
		if body.has_method("get_hit_sound"):
			path = body.get_hit_sound()
		if not isRetracting:
			Global.AudioManager.play_sound_3d(path, 0, global_transform.origin)
		if body.has_method("deconstruct") and canChop:
			chop(body)
	pass # Replace with function body.
