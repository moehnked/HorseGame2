extends "res://Scripts/NPC_Base.gd"




func _on_Interactable_interaction(controller):
	$Interactable.set_interactable(false, true, true)
	pass # Replace with function body.
