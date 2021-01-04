extends "res://Scripts/Item.gd"

var _controller = null
var beingThrown = false
var canSwing:bool = true
var dir:Vector3 = Vector3()
var equippedTo = null
var isRetracting = false
var parent_transform = null
export var speed:int = 100

func _process(delta):
	if beingThrown:
		if isRetracting:
			dir = global_transform.origin.direction_to(equippedTo.global_transform.origin) * speed
		owner.linear_velocity = dir
	global_transform.origin = owner.global_transform.origin
	if parent_transform != null and not beingThrown:
		owner.global_transform.origin = parent_transform.global_transform.origin
		owner.rotation.z = -equippedTo.get_head().rotation.x
		owner.rotation.y = equippedTo.rotation.y
		owner.rotation.x = equippedTo.rotation.z
		owner.rotation.y += deg2rad(-80)

func check_collision(other):
	if other == owner and isRetracting:
		print("axe returned!!")
		equip()
	elif not isRetracting:
		if other != owner and not other.has_method("ignore_unique"):
			collision_effect(other)
		elif other.owner != null:
			if other.owner != owner and not other.owner.has_method("ignore_unique"):
				collision_effect(other.owner)

func collision_effect(other):
	print("axe hit ", other, ", ", other.name)
	isRetracting = true
	if other.has_method("take_damage"):
		other.take_damage(5, self, self)
	elif other.owner != null:
		if other.owner.has_method("take_damage"):
			other.owner.take_damage(5,self,self)

func equip():
	if _controller.owner != null:
		if(_controller.owner.has_method("get_hand")):
			isRetracting = false
			beingThrown = false
			canSwing = true
			owner.linear_velocity = Vector3(0,0,0)
			owner.angular_velocity = Vector3(0,0,0)
			dir = Vector3()
			$AnimationPlayer.play("None")
			_controller.owner.get_hand().update_hand_sprite("Holding")
			_controller.owner.get_hand().set_animation_playback(false)
			_controller.enable_interact()

func interact(controller):
	print(itemName, " picked up by ", controller.owner.name)
	if Utils.get_inventory(controller) != null:
		print("added to ", controller.name, "'s inventory")
		controller.inventory.append(self)
	isInteractable = false
	if controller.has_method("equip"):
		_controller = controller
		controller.equip(self)
		call_deferred("equip")
		equippedTo = controller.owner
		call_deferred("disable_collisions")
		subscribe()

func parse_input(input):
	if input.standard and canSwing and not beingThrown:
		print("axe swing - ", canSwing)
		throw()

func subscribe():
	Global.InputObserver.subscribe(self)

func swing():
	$AnimationPlayer.play("Swing")
	canSwing = false
	_controller.owner.get_hand().toggle_sprite_visibility()

func throw():
	$AnimationPlayer.play("Throw")
	$ThrowDuration.start()
	_controller.owner.get_hand().update_hand_sprite("Idle")
	canSwing = false
	beingThrown = true
	dir = -equippedTo.get_head().global_transform.basis.z * speed

func unsubscribe():
	Global.InputObserver.unsubscribe(self)

func _on_AnimationPlayer_animation_finished(anim_name):
	canSwing = true
	pass # Replace with function body.


func _on_Item_body_entered(body):
	if beingThrown:
		check_collision(body)
	pass # Replace with function body.


func _on_ThrowDuration_timeout():
	if beingThrown:
		isRetracting = true
	pass # Replace with function body.
