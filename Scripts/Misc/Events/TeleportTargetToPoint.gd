extends "res://Scripts/Misc/Events/GenericEvent.gd"

export(NodePath) var point



func _on_TeleportTargetToPoint_emit_event_triggered(by):
	Global.Player.global_transform.origin = get_node(point).global_transform.origin
	pass # Replace with function body.
