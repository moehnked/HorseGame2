extends RigidBody

signal emit_water_entered(droplet)

func disable():
	$CollisionShape.disabled = true
	set_mode(MODE_KINEMATIC)
	visible = false

func enable():
	$CollisionShape.disabled = false
	set_mode(MODE_RIGID)
	visible = true

func enter_water(water):
	emit_signal("emit_water_entered", self)

func get_splash_scale():
	return 0.3

func initialize():
	transform.origin = Vector3.ZERO
	enable()
	apply_central_impulse(Vector3(Utils.get_rng().randf_range(-2,2), Utils.get_rng().randi_range(1,5), Utils.get_rng().randi_range(-2,2)))
	


func _on_Droplet_emit_water_entered(droplet):
	disable()
	pass # Replace with function body.


func _on_Timer_timeout():
	print("droplet time up")
	disable()
	pass # Replace with function body.
