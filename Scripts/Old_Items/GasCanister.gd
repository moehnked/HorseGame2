extends "res://Scripts/Old_Items/Equipable.gd"

var gas:int = 100
var lookingAt = null
var pouringGas = false

func recieve_looking_at(obj):
	if isEquipped:
		if obj.has_method("recieve_gas"):
			lookingAt = obj
		elif obj.get_parent().has_method("recieve_gas"):
			lookingAt = obj.get_parent()

func unequip(controller, caller = null, callback = ""):
	.unequip(controller, caller, callback)
	pass

func equip(controller):
	.equip(controller)

func parse_equip(args = {}):
	args = Utils.check(args, {"input":InputMacro.new()})
	input = args.input
	if input.left_mouse_pressed and not input.standard:
		print("[GC]: pouring gas - ", gas)
		pouringGas = true
	if input.standard:
		gas -= 1
		pouringGas = false
	
	$GasolinePouring/Particles.emitting = pouringGas

func pour_gas():
	gas -= 1
	if lookingAt != null:
		print(lookingAt.name)
		pouringGas = not lookingAt.recieve_gas(1)

func prompt():
	return "pick up - " + String(gas) + "%"

func _on_PourGasTick_timeout():
	if pouringGas:
		pour_gas()
	$PourGasTick.start()
	pass # Replace with function body.
