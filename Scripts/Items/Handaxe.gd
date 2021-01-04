extends "res://Scripts/Items/Equipable.gd"

var beingThrown = false
var canSwing:bool = true
var dir:Vector3 = Vector3()
var isRetracting = false
export var speed:int = 100

func _process(delta):
	parse_input()
	if beingThrown:
		if isRetracting:
			dir = global_transform.origin.direction_to(parentedTo.global_transform.origin) * speed
			if global_transform.origin.distance_to(parentedTo.global_transform.origin) < 2:
				initialize(controller)
		get_parent().linear_velocity = dir
		print(get_parent())
		print(get_parent().linear_velocity)
	if not beingThrown:
		._process(delta)

func equip(controller):
	.equip(controller)
	initialize(controller)

func check_collision(other):
	if other == controller.get_parent() and isRetracting:
		print("axe returned to - ", controller.get_parent().name)
		initialize(controller)
	elif not isRetracting:
		if other != get_parent() and not other.has_method("ignore_unique"):
			collision_effect(other)
		elif other.get_parent() != null:
			if other.get_parent() != get_parent() and not other.get_parent().has_method("ignore_unique"):
				collision_effect(other.get_parent())

func collision_effect(other):
	print("axe hit ", other, ", ", other.name)
	isRetracting = true
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
	if get_parent() != null:
		get_parent().linear_velocity = Vector3(0,0,0)
		get_parent().angular_velocity = Vector3(0,0,0)
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
	controller.get_parent().get_hand().update_hand_sprite("Idle")
	canSwing = false
	beingThrown = true
	isEquipped = false
	dir = -controller.get_parent().get_head().global_transform.basis.z * speed


func _on_ThrowDuration_timeout():
	if beingThrown:
		isRetracting = true
	pass # Replace with function body.


func _on_Item_body_entered(body):
	if beingThrown:
		check_collision(body)
	pass # Replace with function body.
