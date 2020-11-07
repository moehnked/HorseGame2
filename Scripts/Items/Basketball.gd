extends "res://Scripts/Item.gd"
export var launch_power = 200

var _controller = null
var dir = Vector3()
var isInteractable = true
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
	is_interactable = true

func interact(controller):
	controller.inventory.append(self)
	is_interactable = false
	controller.clear()
	controller.disable_interact()
	_controller = controller
	playerRef = controller.owner
	parent_transform = playerRef.get_palm()
	playerRef.revoke_casting()
	playerRef.revoke_menu_options()
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
