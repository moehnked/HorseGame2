extends Spatial

signal emit_start()
signal emit_stop()

var running:bool = false
var oilStore:int = 0
var controller = null
var canister = null
var isDraining:bool = false

func place_canister():
	canister.global_transform.origin = $Interactable.global_transform.origin
	canister.rotation_degrees.y = rotation_degrees.y + 90
	canister.set_mode(RigidBody.MODE_KINEMATIC)
	pass

func get_canister(_controller):
	if Utils.contains("Gas Can", _controller.get_inventory()):
		Utils.uPrint("controller has Gas Canister...", self)
		if _controller.equipped != null:
			if _controller.equipped.itemName == "Gas Can":
				canister = _controller.unequip(false)
				place_canister()
				return
		canister = Utils.pop_item_by_name("Gas Can", _controller.get_inventory())
		Global.world.add_child(canister)
		place_canister()

func _on_Engine_toggle_engine(state):
	running = !running
	$UIPanel.toggle_is_on()
	if running:
		emit_signal("emit_start")
	else:
		emit_signal("emit_stop")
	pass # Replace with function body.


func _on_GrinderGearPillar_emit_grind(groundUp):
	oilStore += Global.world.rng.randi_range(5,20)
	$UIPanel.displayData = oilStore
	pass # Replace with function body.


func _on_Interactable_interaction(_controller):
	if canister != null:
		canister.set_mode(RigidBody.MODE_RIGID)
		canister.interact(_controller)
		canister = null
	else:
		get_canister(_controller)
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
	$DrainTimer.start()
	pass # Replace with function body.
