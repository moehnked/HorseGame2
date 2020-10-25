extends "res://Scripts/Item.gd"
var is_takeable = false
var parent_transform = null
var playerRef = null

func interact(controller):
	if(!is_takeable):
		print("HAHAHHAHA BASKETBALL")
		controller.inventory.append(self)
		is_interactable = false
		controller.clear()
		playerRef = controller.owner
		parent_transform = playerRef.get_palm()
		playerRef.revoke_casting()
		playerRef.revoke_menu_options()

func _process(delta):
	if parent_transform != null:
		global_transform.origin = parent_transform.global_transform.origin
		
		if Input.is_action_just_released("standard"):
			shoot_basket()

func shoot_basket():
	parent_transform = null
	playerRef.restore_menu_options()
	playerRef.enable_casting()
	
