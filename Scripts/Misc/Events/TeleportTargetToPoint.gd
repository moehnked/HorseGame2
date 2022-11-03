extends "res://Scripts/Misc/Events/GenericEvent.gd"

export(NodePath) var point



func _on_TeleportTargetToPoint_emit_event_triggered(by):
	var p = get_node(point)
	Global.Player.global_transform.origin = (p if p != null else self).global_transform.origin
	for h in Global.Player.get_party():
		#h.global_transform.origin = Global.Player.global_transform.origin + (Vector3(Utils.rand_float_range(10,30),Utils.rand_float_range(10,30),Utils.rand_float_range(10,30)))
		h.global_transform.origin = Global.Player.global_transform.origin
		print("h ,", h.get_parent()," ",h.owner," - ", h.global_transform.origin)
	pass # Replace with function body.
