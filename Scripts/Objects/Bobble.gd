extends RigidBody

var isReeling = false
var rod
var hooked = null
var waterRef

signal emit_water_entered()

func _process(delta):
	if isReeling:
		if hooked != null:
			hooked.global_transform.origin = global_transform.origin
		global_transform.origin = global_transform.origin.linear_interpolate(rod.global_transform.origin, 0.3)
		if global_transform.origin.distance_squared_to(rod.global_transform.origin) < 2:
			queue_free()
	elif Input.is_action_just_pressed("standard") or Input.is_action_just_pressed("special"):
		Global.AudioManager.play_sound("res://Sounds/fishingrodUnequip.wav")
		start_reel()

func enter_water(water):
	$AnimationPlayer.play("Bob")
	$Timer.start(Utils.get_rng().randf_range(2,15))
	$CollisionShape.disabled = true
	Utils.freeze_rigidbody(self)
	rod.get_caster().unsubscribe_to()
	waterRef = water
	#queue_free()

func initialize(r):
	rod = r

func queue_free():
	if hooked != null:
		hooked.add_self_to_inventory(rod.controller, true)
	rod.retrieve_bobble()
	rod.canCast = true
	.queue_free()

func start_reel():
	isReeling = true
	Utils.freeze_rigidbody(self, false)
	var href = rod.get_caster().get_hand()
	href.play_animation("Fishing_Cast")

func _on_Timer_timeout():
	start_reel()
	hooked = waterRef.get_fishable_item()
	hooked = Global.world.instantiate(hooked, global_transform.origin)
	pass # Replace with function body.
