#Equipable.gd
extends "res://Scripts/NewItems/Item.gd"

var equipState:String = "Equip"
var input = InputMacro.new()
var isEquipped:bool = false
var parentedTo:Spatial = Spatial.new()

export var canInteractWhileEquipped:bool = false
export var equipSoundPath:String = "res://Sounds/unequip_01.wav"
export var unequipSoundPath:String = "res://Sounds/equipment_03.wav"
export var intendedSprite = "Holding"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if isEquipped:
		update_position_to_parent()
		update_rotation_to_parent()
		pass

func clear_context():
	get_context().clear_equipment_context()

func equip(_controller):
	controller = _controller
	if controller.equip(self):
		isEquipped = true
		set_context("Unequip")
		Global.AudioManager.play_sound(equipSoundPath)
		return true
	return false

func interact(_controller):
	print("EQUIP!!")
	if not equip(_controller):
		pickup(_controller)

func parse_equipped(args = {}):
	args = Utils.check(args, {"input":InputMacro.new()})
	input = args.input

func set_context(_equipState):
	print("equipable",self,": setting context to ", _equipState)
	var prev = null
	var newContext = null
	clear_context()
	equipState = _equipState
	match equipState:
		"Equip":
			newContext = get_context().add("Equip")
		"Unequip":
			newContext = get_context().add("Unequip")
#	match equipState:
#		"Equip":
#			prev = get_context().get_unequip()
#			get_context().remove_child(prev)
#			print("setcontext equip:",prev)
#			if prev != null:
#				prev.queue_free()
#			newContext = get_context().get_equip()
#			if newContext == null:
#				 newContext = get_context().add("Equip")
#		"Unequip":
#			prev = get_context().get_equip()
#			print("setcontext unequip:",prev)
#			get_context().remove_child(prev)
#			if prev != null:
#				prev.queue_free()
#			newContext = get_context().get_unequip()
#			if newContext == null:
#				newContext = get_context().add("Unequip")
	newContext.initialize({"item": self, "controller": controller})
	newContext.visible = false
	print("Setting context:")
	print(get_context().get_children())

func set_point(object, _controller):
	print("setting parent of ",name, " to ", object.name, " / ", _controller.name)
	controller = _controller
	parentedTo = object

func unequip():
	print("equ:",name,": unequipping")
	set_context("Equip")
	isEquipped = false
	parentedTo = Spatial.new()
	controller = null
	Global.AudioManager.play_sound(unequipSoundPath)
	$Interactable.set_interactable(true)
	

func update_position_to_parent():
	global_transform.origin = parentedTo.global_transform.origin

func update_rotation_to_parent():
	rotation.z = -controller.get_parent().get_x_rotation()
	rotation.y = controller.get_parent().rotation.y
	rotation.x = controller.get_parent().get_head().rotation.z
	rotation.y += deg2rad(-80)
