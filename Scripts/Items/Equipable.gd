#Equipable.gd
extends "res://Scripts/Items/Item.gd"

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
		if controller.get_parent().has_method("get_x_rotation"):
			update_rotation_to_parent()
		pass

func clear_context():
	get_context().clear_equipment_context()

func equip(_controller):
	print("[eq]",self,":equip - ", isEquipped)
	controller = _controller
	if _controller.has_method("get_equipment_manager"):
		controller = _controller.get_equipment_manager()
	if controller.equip(self):
		print("successfully equipped")
		$Interactable.isInteractable = false
		isEquipped = true
		set_context("Unequip")
		Global.AudioManager.play_sound(equipSoundPath)
		return true
	return false

func interact(_controller):
	print("[eq]:interact")
	if not equip(_controller):
		pickup(controller)

func parse_equip(args = {}):
	args = Utils.check(args, {"input":InputMacro.new()})
	input = args.input

func recieve_looking_at(by, obj):
	pass

func set_context(_equipState):
	var prev = null
	var newContext = null
	clear_context()
	equipState = _equipState
	match equipState:
		"Equip":
			newContext = get_context().add("Equip")
		"Unequip":
			newContext = get_context().add("Unequip")
	newContext.initialize({"item": self, "controller": controller})
	newContext.visible = false

func set_point(object, _controller):
	print("setting point to ", object)
	controller = _controller
	parentedTo = object

func unequip(args = {}):
	args = Utils.check(args, {"caller":null})
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
