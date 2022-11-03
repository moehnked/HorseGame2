extends "res://Scripts/Misc/Events/GenericEvent.gd"

export(int) var chips = 1
export(int) var cost = 5



func _on_PurchaseChipsEvent_emit_event_triggered(by):
	var p = Global.Player
	if p.get_treats() >= cost:
		print("purchasing ", chips, " chips for ", cost, " treats.")
		p.treats -= cost
		p.chips += chips
		Dialogic.set_variable("purchasedChipsSuccess", 1)
	pass # Replace with function body.
