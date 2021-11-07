extends Spatial

export(NodePath) var areaPoint
export(String) var locationName = "area"
export(String) var prefix = "Enter"


func _on_Interactable_emit_prompt(_prompt):
	_prompt.prompt = prefix + ": " + locationName
	pass # Replace with function body.


func _on_Interactable_interaction(controller):
	#print(controller, controller.name)
	var point = get_node(areaPoint)
	var other = controller.get_parent()
	other.global_transform.origin = point.global_transform.origin
	pass # Replace with function body.
