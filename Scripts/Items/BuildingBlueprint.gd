extends "res://Scripts/Items/Useable.gd"


export(String) var plan = "Fence"

func _on_BuildingBlueprint_emit_item_used(item):
	Global.Player.call("add_blueprint", plan)
	pass # Replace with function body.
