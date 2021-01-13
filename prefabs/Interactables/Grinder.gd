extends Spatial

signal emit_start()
signal emit_stop()

var running:bool = false
var oilStore:int = 0
var controller = null
var canister = null
var isDraining:bool = false

func instance_gas_canister(l):
	var obj = Global.world.instantiate(l.prefabPath, $Interactable.global_transform.origin)
	obj.rotation_degrees.y = rotation_degrees.y + 90
	canister = obj.get_node("Item")
	controller.get_inventory().erase(l)
	l.queue_free()

func place_canister(_controller):
	Utils.uPrint("placing canister", self)
	controller = _controller
	if Utils.contains("Gas Canister", controller.get_inventory()):
		var l = Utils.pop_item_by_name("Gas Canister", controller.get_inventory())
		Utils.uPrint("controller has Gas Canister...", self)
		if l.has_method("unequip"):
			if l.isEquipped:
				print("unequipping ", l.name)
				l.unequip(controller, self, "instance_gas_canister")
				return
		instance_gas_canister(l)

func _on_Engine_toggle_engine(state):
	running = !running
	$UIPanel.toggle_is_on()
	if running:
		emit_signal("emit_start")
	else:
		emit_signal("emit_stop")
	pass # Replace with function body.


func _on_GrinderGearPillar_emit_grind(groundUp):
	oilStore += Global.world.rng.randi_range(5,15)
	$UIPanel.displayData = oilStore
	pass # Replace with function body.


func _on_Interactable_interaction(_controller):
	if canister != null:
		canister.interact(_controller)
		canister = null
	else:
		place_canister(_controller)
	pass # Replace with function body.


func _on_Interactable_emit_prompt(_prompt):
	if canister != null:
		_prompt.prompt = "Retrieve : " + String(canister.gas) + "%"
	else:
		_prompt.prompt = "Place Container"
	pass # Replace with function body.


func _on_UIPanel_emit_holding(controller):
	if canister != null:
		isDraining = true
	else:
		isDraining = false
	pass # Replace with function body.


func _on_UIPanel_emit_release():
	isDraining = false
	pass # Replace with function body.


func _on_DrainTimer_timeout():
	if isDraining and canister != null and oilStore > 0:
		canister.gas += 1
		oilStore -= 1
		$UIPanel.displayData = oilStore
	pass # Replace with function body.
