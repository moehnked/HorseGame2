extends "res://Scripts/Item.gd"

var controller = null
var input = InputMacro.new()
var isEquipped:bool = false
var parentedTo:Spatial = Spatial.new()
var rigidbody:RigidBody = RigidBody.new()

export var intendedSprite = "Holding"

func _ready():
	print("prefab path for ", itemName, ": ", prefabPath)
	rigidbody = load(prefabPath).instance()
	rigidbody.remove_child(rigidbody.get_node("Item"))

func _process(delta):
	if isEquipped:
		update_position_to_parent()
		pass

func overidable_function():
	pass

func destroy():
	print(get_parent().name, ": equipable: destroying self....")
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
	isEquipped = true
	set_context("Unequip")

func get_rigidbody():
	return rigidbody

func interact(controller):
	equip(controller)
	#destroy()

func parse_equip(args = {}):
	args = Utils.check(args, {"input":InputMacro.new()})
	input = args.input

func set_context(equipState):
	var prev = null
	var newContext = null
	match equipState:
		"Equip":
			prev = get_context().get_unequip()
			get_context().remove_child(prev)
			prev.queue_free()
			newContext = get_context().add("Equip")
		"Unequip":
			prev = get_context().get_equip()
			get_context().remove_child(prev)
			prev.queue_free()
			newContext = get_context().add("Unequip")
	newContext.initialize({"item": self, "controller": controller})

func set_point(object, _controller):
	print("setting parent of ",name, " to ", object.name, " / ", _controller.name)
	controller = _controller
	parentedTo = object

func unequip(controller, caller = null):
	print("[equipable]: unequiping ", get_parent().name)
	var i = controller.unequip(self)
	i.set_context("Equip")
	if caller != null:
		caller.set_item(i)
	destroy()
	pass

func update_position_to_parent():
	get_parent().global_transform.origin = parentedTo.global_transform.origin
	global_transform.origin = get_parent().global_transform.origin
	get_parent().rotation.z = -controller.get_parent().get_x_rotation()
	get_parent().rotation.y = controller.get_parent().rotation.y
	get_parent().rotation.x = controller.get_parent().get_head().rotation.z
	get_parent().rotation.y += deg2rad(-80)
