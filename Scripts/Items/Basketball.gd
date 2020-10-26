extends "res://Scripts/Item.gd"
var parent_transform = null
var playerRef = null
export var launch_power = 100

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
	playerRef = controller.owner
	parent_transform = playerRef.get_palm()
	playerRef.revoke_casting()
	playerRef.revoke_menu_options()
	disable_collisions()


func shoot_basket():
	var dir = launch_power * (parent_transform.global_transform.origin - playerRef.global_transform.origin)
	owner.apply_central_impulse(dir)
	parent_transform = null
	playerRef.restore_menu_options()
	playerRef.enable_casting()
	owner.get_node("Timer").start()



func _on_Timer_timeout():
	print("basketball collisions re-enabled")
	enable_collisions()
