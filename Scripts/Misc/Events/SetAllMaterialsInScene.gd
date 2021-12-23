extends "res://Scripts/Misc/Events/GenericEvent.gd"


func _on_SetAllMaterialsInScene_emit_event_triggered(by):
	set_materials_helper(Global.world)
	pass # Replace with function body.


func set_materials_helper(node):
	print("setting all materials ", node," ", get_child_count())
	if node is MeshInstance:
		var smCount = node.get_surface_material_count()
		if smCount > 0:
			print("found ", smCount, "materials")
			var m = 0
			while m < smCount:
				var mat = node.get_surface_material(m)
				print("Material ",m, " - ", mat)
				if mat is SpatialMaterial:
					print("setting depth test to false")
					#mat.flags_no_depth_test = val
					mat.set_distance_fade(SpatialMaterial.DISTANCE_FADE_PIXEL_DITHER)
					mat.set_distance_fade_min_distance(160)
					mat.set_distance_fade_max_distance(70)
				m += 1
	var num = node.get_child_count()
	if num > 0:
		for n in node.get_children():
			set_materials_helper(n)

