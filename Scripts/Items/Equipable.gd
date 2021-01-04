extends "res://Scripts/Item.gd"

var controller = null
var input = InputMacro.new()
var isEquipped:bool = false
var parentedTo:Spatial = Spatial.new()

func _process(delta):
	if isEquipped:
		get_parent().global_transform.origin = parentedTo.global_transform.origin
		global_transform.origin = get_parent().global_transform.origin
		get_parent().rotation.z = -controller.get_parent().get_x_rotation()
		get_parent().rotation.y = controller.get_parent().rotation.y
		get_parent().rotation.x = controller.get_parent().get_head().rotation.z
		get_parent().rotation.y += deg2rad(-80)
		pass

func destroy():
	get_parent().queue_free()

func disable_collisions():
	get_parent().set_collision_mask_bit(2, 0)

func enable_collisions():
	get_parent().set_collision_mask_bit(2, 1)
	isInteractable = true

func equip(_controller):
	print("equipping: ",self)
	controller = _controller
	controller.equip(self)
	#isEquipped = true
	#remove_child(.get_context().get_equip())
	#.get_context().add_child(load("res://prefabs/UI/ItemContext_Unequip.tscn").instance())

func interact(controller):
#	var o = get_parent().duplicate()
#	Global.world.call_deferred("add_child", o)
#	o.get_node("Item").equip(controller)
	#.add_to_inventory(controller)
	equip(controller)
	destroy()
	#.interact(controller)

func parse_equip(args = {}):
	args = Utils.check(args, {"input":InputMacro.new()})
	input = args.input

func set_point(object, _controller):
	#print("setting parent of ",name, " to ", object.name, " / ", _controller.name)
	controller = _controller
	parentedTo = object

func unequip(controller, caller):
	caller.set_item(controller.unequip(self))
	destroy()
	pass
