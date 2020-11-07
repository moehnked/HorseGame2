extends Area2D

var buildRef = null
var selection = []

func initialize(ref):
	buildRef = ref

func update_selection():
	if(selection.size() > 0):
		buildRef.selected = selection[0]

func _on_Pointer_area_shape_entered(area_id, area, area_shape, self_shape):
	if(area.has_method("get_prefab")):
		print("~~ entered ", area.get_prefab())
		selection.append(area)
	update_selection()
	pass # Replace with function body.



func _on_Pointer_area_shape_exited(area_id, area, area_shape, self_shape):
	if(area.has_method("get_prefab")):
		if(selection.has(area)):
			selection.erase(area)
	update_selection()
	pass # Replace with function body.
