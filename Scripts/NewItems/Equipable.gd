extends "res://Scripts/NewItems/Item.gd"

var equipState:String = "Equip"
var input = InputMacro.new()
var isEquipped:bool = false
var parentedTo:Spatial = Spatial.new()

export var equipSoundPath:String = "res://Sounds/unequip_01.wav"
export var intendedSprite = "Holding"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func equip(_controller):
	controller = _controller
	controller.equip(self)
	pass

func interact(_controller):
	print("EQUIP!!")
	equip(_controller)

func parse_equip(args = {}):
	args = Utils.check(args, {"input":InputMacro.new()})
	input = args.input

func set_point(object, _controller):
	print("setting parent of ",name, " to ", object.name, " / ", _controller.name)
	controller = _controller
	parentedTo = object
