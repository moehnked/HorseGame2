extends "res://Scripts/Items/Placeable.gd"

var CanBuild = false

func _process(delta):
	if isEquipped:
		$BoundingBoxMesh.visible = false
	else:
		$BoundingBoxMesh.visible = true
		if hasBeenPlaced:
			calculate_distance()
	pass

func calculate_distance():
	var dist = global_transform.origin.distance_squared_to(Global.Player.global_transform.origin)
	var valid = dist < 2100
	if valid != CanBuild:
		update_building_rights(valid)
	pass

func update_building_rights(canBuild):
	CanBuild = canBuild
	print("Within Building Area")
	Global.Player.hasBuildingRights = canBuild
	Global.InteractionPrompt.show_context("You have obtained Building Rights!" if canBuild else "You have lost Building Rights!")
