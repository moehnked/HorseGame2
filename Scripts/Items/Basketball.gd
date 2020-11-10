extends "res://Scripts/Item.gd"
export var launch_power = 200

var _controller = null
var dir = Vector3()
var parent_transform = null
var playerRef = null


func _process(delta):
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
	if .get_inventory(controller) != null:
		controller.inventory.append(self)
	isInteractable = false
	if controller.has_method("equip"):
		controller.equip(self)
	_controller = controller
	playerRef = controller.owner
	disable_collisions()


func shoot_basket():
	dir = -playerRef.get_head().global_transform.basis.z
	owner.linear_velocity = dir * launch_power
	parent_transform = null
	playerRef.restore_menu_options()
	playerRef.enable_casting()
	playerRef.get_inventory().erase(self)
	owner.get_node("Timer").start()
	_controller.enable_interact()



func _on_Timer_timeout():
	print("basketball collisions re-enabled")
	enable_collisions()
