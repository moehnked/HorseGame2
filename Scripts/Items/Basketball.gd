extends "res://Scripts/Items/Equipable.gd"
export var launch_power = 15

var basket = null
var dir = Vector3()
var isAtemptingShot = false
var parent_transform = null
var shoot_position = Vector3()

func _process(delta):
	if input.standard and isEquipped and not isAtemptingShot:
		shoot_basket()

func disable_collisions():
	owner.set_collision_mask_bit(2, 0)

func enable_collisions():
	owner.set_collision_mask_bit(2, 1)
	isInteractable = true
	
func get_basket():
	return basket

func get_shooter():
	return controller.owner

func initialize():
	print("initializing bbal")
	controller = null
	parentedTo = Spatial.new()
	isAtemptingShot = false
	shoot_position = Vector3()
	basket = null
	dir = Vector3()

func interact(controller):
	.equip(controller)
	controller.disable_interact()
	isAtemptingShot = false

func is_basketball():
	return true

func made_shot():
	isAtemptingShot = false

func parse_input(input):
	if input.standard:
			shoot_basket()

func set_basket(_basket):
	basket = _basket

func shoot_basket():
	print("shooting shot")
	var p = controller.owner
	var dir = Vector3()
	if p.has_method("get_head"):
		dir = -p.get_head().global_transform.basis.z
	print("shooting in dir ", dir)
	get_parent().linear_velocity = dir * launch_power
	isAtemptingShot = true
	unequip(controller)
#
#func shoot_basket(vector = null, thrown_from = null):
#	if vector != null and thrown_from != null:
#		print("option 1")
#		dir = global_transform.origin.direction_to(basket.get_node("Ring_Point").global_transform.origin)
#	elif(controller.owner.has_method("get_head")):
#		dir = -controller.owner.get_head().global_transform.basis.z
#	else:
#		print("option 3")
#		dir = global_transform.origin.direction_to((basket.get_node("Ring_Point").global_transform.origin + Vector3(0,5,0))) * 1.2
#	get_parent().linear_velocity = dir * launch_power
#	parent_transform = null
#	if(controller.owner.has_method("is_player")):
#		controller.owner.restore_menu_options()
#		controller.owner.enable_casting()
#	controller.owner.get_inventory().erase(self)
#	#get_parent().get_node("Timer").start()
#	Global.world.queue_timer(self, 0.1, "enable_collisions")
#	controller.enable_interact()
#	shoot_position = controller.owner.global_transform.origin
#	isAtemptingShot = true

func unequip(controller, caller = null):
	isEquipped = false
	if caller != null:
		.unequip(controller, caller)
	controller.disconnect_item(self)
	controller = null
	parentedTo = Spatial.new()
	input = InputMacro.new()
	set_context("Equip")

func _on_Timer_timeout():
	print("basketball collisions re-enabled")
	enable_collisions()


func _on_Item_body_entered(body):
	if(body.has_method("is_ground")):
		print("basketball landed")
		if(isAtemptingShot):
			isAtemptingShot = false
			print("missed that one, bud! - ", isAtemptingShot)
			if basket != null:
				basket.set_score(controller.owner.name, 0)
	pass # Replace with function body.
