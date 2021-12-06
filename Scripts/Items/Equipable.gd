#Equipable.gd
extends "res://Scripts/Items/Item.gd"

#const horseRef = preload("res://Scripts/Horse/Horse.gd")

var equipState:String = "Equip"
var input = InputMacro.new()
var isEquipped:bool = false
var parentedTo:Spatial = Spatial.new()

export var canInteractWhileEquipped:bool = false
export var equipSoundPath:String = "res://Sounds/unequip_01.wav"
export var unequipSoundPath:String = "res://Sounds/equipment_03.wav"
export var intendedSprite = "Holding"

func _process(delta):
	if isEquipped:
		set_interactable(false, true)
		#print("equiped")
		update_position_to_parent()
		if controller.get_parent().has_method("get_x_rotation"):
			update_rotation_to_parent()
		pass

func apply_behavior(HB):
	if HB != null:
		var p = controller.get_parent()
		if p != null:
			print("p is ", p.name)
			#if p is horseRef:
			if p is Horse:
				print("applying to horse")
				p.call("add_behavior", HB)
				p.call("set_state", Utils.check(HB.initialArgs, {"behaviorName":HB.stateName}))

func clear_context():
	get_context().clear_equipment_context()

func equip(_controller):
	print("equipable:",self.name,":equip - ", isEquipped)
	controller = _controller
	if _controller.has_method("get_equipment_manager"):
		controller = _controller.get_equipment_manager()
	if controller.equip(self):
		print("successfully equipped")
		set_sleeping(false)
		toggle_collisions(false)
		$Interactable.isInteractable = false
		isEquipped = true
		set_context(Context.Context.Equip)
		Global.AudioManager.play_sound(equipSoundPath)
		apply_behavior(get_behavior())
		return true
	return false

func interact(_controller):
	print("equipable::interact")
	if not equip(_controller):
		pickup(controller)

func parse_equip(args = {}):
	args = Utils.check(args, {"input":InputMacro.new()})
	input = args.input

func recieve_looking_at(by, obj):
	pass

func set_context(_equipState):
	var i = ContextOptions.find(_equipState)
	ContextOptions[i] = Context.Context.Equip if _equipState == Context.Context.Unequip else Context.Context.Unequip
#
#func set_context(_equipState):
#	var prev = null
#	var newContext = null
#	#clear_context()
#	equipState = _equipState
#	match equipState:
#		"Equip":
#			newContext = get_context().add("Equip")
#		"Unequip":
#			newContext = get_context().add("Unequip")
#	newContext.initialize({"item": self, "controller": controller})
#	newContext.visible = false

func set_point(object, _controller):
	#print("setting point to ", object)
	controller = _controller
	parentedTo = object

func toggle_collisions(enabl = true):
	for i in get_children():
		if i is CollisionShape:
			i.disabled = not enabl
	

func unequip(args = {}):
	args = Utils.check(args, {"caller":null})
	set_context(Context.Context.Unequip)
	isEquipped = false
	parentedTo = Spatial.new()
	controller = null
	Global.AudioManager.play_sound(unequipSoundPath)
	$Interactable.set_interactable(true)
	toggle_collisions(true)
	

func update_position_to_parent():
	global_transform.origin = parentedTo.global_transform.origin

func update_rotation_to_parent():
	rotation.z = -controller.get_parent().get_x_rotation()
	rotation.y = controller.get_parent().rotation.y
	rotation.x = controller.get_parent().get_head().rotation.z
	rotation.y += deg2rad(-80)
