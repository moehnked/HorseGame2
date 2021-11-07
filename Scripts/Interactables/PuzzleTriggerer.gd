extends Spatial

export(String) var targetGroup = ""
export(NodePath) var targetNode = null

signal emit_activated()

func activate():
	emit_signal("emit_activated")
	if targetNode != null:
		get_node(targetNode).trigger(self)
	if targetGroup != "":
		Global.world.get_tree().call_group(targetGroup, "trigger", self)

