extends Area

var isUnderwater:bool = false

func get_head():
	return owner.get_head()

func start_swimming():
	#get_head().set_mask(Color(0, 0.70, 0.98, 0.32))
	$Mask/WaterSheet.visible = true
	pass

func stop_swimming():
	$Mask/WaterSheet.visible = false
	#get_head().set_mask(Color(1,1,1,0))
	pass


func _on_Area_area_entered(area):
	if area.has_method("is_water"):
		print("mask underwater")
		isUnderwater = true
		start_swimming()
	pass # Replace with function body.


func _on_Area_area_exited(area):
	if area.has_method("is_water") and isUnderwater:
		print("nolonger underwater")
		isUnderwater = false
		stop_swimming()
	pass # Replace with function body.
