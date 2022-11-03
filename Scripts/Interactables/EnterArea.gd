extends Spatial

export(NodePath) var areaPoint
export(String) var locationName = "area"
export(String) var prefix = "Enter"


func _on_Interactable_emit_prompt(_prompt):
	_prompt.prompt = prefix + ": " + locationName
	pass # Replace with function body.


func _on_Interactable_interaction(controller):
	#print(controller, controller.name)
	var point = get_node(areaPoint).global_transform.origin
	var other = controller.get_parent()
	other.global_transform.origin = point
	if other.has_method("get_party"):
		move_party(other.call("get_party"), point)
	pass # Replace with function body.

func move_party(party, point):
	var rng = Global.world.get_rng()
	for o in party:
		var r = rng.randi_range(-4,4)
		o.global_transform.origin = point + Vector3(r,r,r)
