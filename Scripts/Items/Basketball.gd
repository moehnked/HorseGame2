extends "res://Scripts/Item.gd"
export var launch_power = 210

var basket = null
var _controller = null
var dir = Vector3()
var isAtemptingShot = false
var parent_transform = null
var playerRef = null
var shoot_position = Vector3()


func _process(delta):
	global_transform.origin = owner.global_transform.origin
	if parent_transform != null:
		owner.global_transform.origin = parent_transform.global_transform.origin

func destroy():
	owner.queue_free()

func disable_collisions():
	owner.set_collision_mask_bit(2, 0)

func enable_collisions():
	owner.set_collision_mask_bit(2, 1)
	isInteractable = true

func equip():
	playerRef = _controller.owner
	disable_collisions()
	subscribe()

func get_basket():
	return basket

func get_shooter():
	return playerRef

func interact(controller):
	print(itemName, " picked up by ", controller.owner.name)
	if .get_inventory(controller) != null:
		print("added to ", controller.name, "'s inventory")
		controller.inventory.append(self)
	isInteractable = false
	if controller.has_method("equip"):
		controller.equip(self)
	_controller = controller
	equip()

func is_basketball():
	return true

func made_shot():
	isAtemptingShot = false

func parse_input(input):
	if input.standard:
			shoot_basket()

func set_basket(_basket):
	basket = _basket

func shoot_basket(vector = null, thrown_from = null):
	if vector != null and thrown_from != null:
		print("option 1")
		dir = global_transform.origin.direction_to(basket.get_node("Ring_Point").global_transform.origin)
	elif(playerRef.has_method("get_head")):
		dir = -playerRef.get_head().global_transform.basis.z
	else:
		print("option 3")
		dir = global_transform.origin.direction_to((basket.get_node("Ring_Point").global_transform.origin + Vector3(0,5,0))) * 1.2
	owner.linear_velocity = dir * launch_power
	parent_transform = null
	if(playerRef.has_method("is_player")):
		playerRef.restore_menu_options()
		playerRef.enable_casting()
	playerRef.get_inventory().erase(self)
	owner.get_node("Timer").start()
	_controller.enable_interact()
	shoot_position = playerRef.global_transform.origin
	isAtemptingShot = true

func subscribe():
	Global.InputObserver.subscribe(self)

func unsubscribe():
	Global.InputObserver.unsubscribe(self)

func _on_Timer_timeout():
	print("basketball collisions re-enabled")
	enable_collisions()


func _on_Item_body_entered(body):
	if(body.has_method("is_ground")):
		print("basketball landed")
		if(isAtemptingShot):
			isAtemptingShot = false
			print("missed that one, bud!")
			if basket != null:
				basket.set_score(playerRef.name, 0)
	pass # Replace with function body.
