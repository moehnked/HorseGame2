extends "res://Scripts/Item.gd"
export var launch_power = 200

var _controller = null
var dir = Vector3()
var parent_transform = null
var playerRef = null
var shoot_position = Vector3()


func _process(delta):
	global_transform.origin = owner.global_transform.origin
	if parent_transform != null:
		owner.global_transform.origin = parent_transform.global_transform.origin

		if Input.is_action_just_released("standard"):
			shoot_basket()

func disable_collisions():
	owner.set_collision_mask_bit(2, 0)

func enable_collisions():
	owner.set_collision_mask_bit(2, 1)
	isInteractable = true

func interact(controller):
	print(itemName, " picked up by ", controller.owner.name)
	if .get_inventory(controller) != null:
		print("added to ", controller.name, "'s inventory")
		controller.inventory.append(self)
	isInteractable = false
	if controller.has_method("equip"):
		controller.equip(self)
	_controller = controller
	playerRef = controller.owner
	#shoot_position = controller.owner.global_transform.origin
	disable_collisions()

func is_basketball():
	return true

func shoot_basket():
	if(playerRef.has_method("get_head")):
		dir = -playerRef.get_head().global_transform.basis.z
	else:
		dir = -playerRef.global_transform.basis.z
	#print(playerRef, " - ", playerRef.name)
	#dir = -playerRef.get_head().global_transform.basis.z
	owner.linear_velocity = dir * launch_power
	parent_transform = null
	if(playerRef.has_method("is_player")):
		playerRef.restore_menu_options()
		playerRef.enable_casting()
	playerRef.get_inventory().erase(self)
	owner.get_node("Timer").start()
	_controller.enable_interact()
	shoot_position = playerRef.global_transform.origin



func _on_Timer_timeout():
	print("basketball collisions re-enabled")
	enable_collisions()
