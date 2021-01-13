#CLASS : THROWABLE
extends "res://Scripts/Items/Equipable.gd"


export var launch_power = 15


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func parse_equip(args = {}):
	args = Utils.check(args, {"input": InputMacro.new()})
	var input = args.input
	if input.standard:
		throw()

func take_damage(dmg = 1, hitbox = null, source = null):
	if dmg == 100 and !isEquipped:
		if source.has_method("grind_fossil"):
			if source.grind_fossil(self):
				spawn_effect()
				unequip(controller)
				queue_free()

func spawn_effect():
	pass

func throw():
	print("shooting shot")
	var p = controller.owner
	var dir = Vector3()
	if p.has_method("get_head"):
		dir = -p.get_head().global_transform.rotated(Vector3(1,0,0), deg2rad(-20)).basis.z
	print("shooting in dir ", dir)
	get_parent().linear_velocity = dir * launch_power
	unequip(controller)

func unequip(controller, caller = null, callback = ""):
	print(get_parent().name,": unequipping from ", controller.name, " by ", caller)
	isEquipped = false
	if caller != null:
		.unequip(controller, caller, callback)
	else:
		controller.disconnect_item(self)
		controller = null
		parentedTo = Spatial.new()
		input = InputMacro.new()
		set_context("Equip")
