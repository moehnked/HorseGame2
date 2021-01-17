extends "res://Scripts/NewItems/Throwable.gd"

var beingThrown = false
var canChop:bool = true
var canSwing:bool = true
var dir:Vector3 = Vector3()
var isRetracting = false

func _process(delta):
	parse_input()
	if beingThrown:
		if isRetracting:
			dir = global_transform.origin.direction_to(parentedTo.global_transform.origin) * power
			if global_transform.origin.distance_to(parentedTo.global_transform.origin) < 2:
				initialize(controller)
		linear_velocity = dir
	if not beingThrown:
		._process(delta)

func check_collision(other):
	if other == controller.get_parent() and isRetracting:
		print("axe returned to - ", controller.get_parent().name)
		initialize(controller)
	elif not isRetracting:
		if other != self and not other.has_method("ignore_unique"):
			collision_effect(other)
		elif other.get_parent() != null:
			if other.get_parent() != self and not other.get_parent().has_method("ignore_unique"):
				collision_effect(other.get_parent())

func collision_effect(other):
	print("axe hit ", other, ", ", other.name)
	isRetracting = true
	canChop = false
	$ChopTimer.start()
	if other.has_method("take_damage"):
		other.take_damage(5, self, self)
	elif other.get_parent() != null:
		if other.get_parent().has_method("take_damage"):
			other.get_parent().take_damage(5,self,self)

func initialize(controller):
	isRetracting = false
	beingThrown = false
	canSwing = true
	isEquipped = true
	canChop = true
	linear_velocity = Vector3(0,0,0)
	angular_velocity = Vector3(0,0,0)
	dir = Vector3()
	var h = controller.get_parent().get_hand()
	h.update_hand_sprite("Holding")
	h.set_animation_playback(false)

func parse_input():
	if input.standard and canSwing and not beingThrown:
		throw()

func throw():
	print("axe thrown")
	#$AnimationPlayer.play("Throw")
	$ThrowDuration.start()
	controller.get_parent().get_hand().update_hand_sprite("Idle", true)
	#controller.set_hand_playback(true)
	canSwing = false
	beingThrown = true
	isEquipped = false
	dir = -controller.get_parent().get_head().global_transform.basis.z * power


func _on_ThrowDuration_timeout():
	isRetracting = true
	pass # Replace with function body.


func _on_Handaxe_body_entered(body):
	if beingThrown and body != self and canChop:
		var path = "res://Sounds/axe_hit_01.wav"
		if body.has_method("get_hit_sound"):
			path = body.get_hit_sound()
		#Global.AudioManager.play_sound(path)
		Global.AudioManager.play_sound_3d(path, 0, global_transform.origin)
		var par = 1 if Global.world.rng.randf() > 0.5 else -1
		var v =  Vector3(Global.world.rng.randf() * par,Global.world.rng.randf() * -par,Global.world.rng.randf() * par) * 30
		print("collided! : ", body.name)
		angular_velocity = v
		check_collision(body)
	pass # Replace with function body.


func _on_ChopTimer_timeout():
	canChop = true
	pass # Replace with function body.
