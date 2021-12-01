extends "res://Scripts/Misc/GenericEventTrigger.gd"

export(NodePath) var triggeringNode = null
export(Array, String) var triggeringGroups = []


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func on_area_triggered(body):
	if triggeringNode != null:
		if get_node(triggeringNode) == body:
			target_triggered()
	else:
		if Global.world != null:
			for i in triggeringGroups:
				for o in Global.world.get_tree().get_nodes_in_group(i):
					if o == body:
						target_triggered()
						return
					pass
	
