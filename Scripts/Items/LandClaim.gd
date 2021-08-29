extends "res://Scripts/Items/Placeable.gd"

func _process(delta):
	if isEquipped:
		$BoundingBox/CollisionShape.disabled = true
	else:
		$BoundingBox/CollisionShape.disabled = false
	pass

func update_building_rights(body, canBuild):
	if body == Global.Player and hasBeenPlaced:
		print("Within Building Area")
		body.hasBuildingRights = canBuild
	

func _on_BoundingBox_body_entered(body):
	update_building_rights(body, true)
	pass # Replace with function body.



func _on_BoundingBox_body_exited(body):
	update_building_rights(body, false)
	pass # Replace with function body.
