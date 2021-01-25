extends "res://Scripts/Objects/Destructable.gd"

var gateRef = null
var leftLink = null
var rightLink = null

func _on_SnapZone_area_entered(area):
	#print("~~~~~~~", area.name)
	if area.has_method("link"):
		#print("snapping ", area.name)
		if($LeftPost.global_transform.origin.distance_to(area.global_transform.origin) < $RightPost.global_transform.origin.distance_to(area.global_transform.origin)):
			leftLink = area
		else:
			rightLink = area
		area.link(self)
	elif(area.owner != null):
		if area.owner.has_method("link"):
			#print("snapping ", area.owner.name)
			if($LeftPost.global_transform.origin.distance_to(area.owner.global_transform.origin) < $RightPost.global_transform.origin.distance_to(area.owner.global_transform.origin)):
				leftLink = area.owner
			else:
				rightLink = area.owner
			area.owner.link(self)

func link(other, isGate = false):
	print("linking ", other.name," to ->")
	if($LeftPost.global_transform.origin.distance_to(other.global_transform.origin) < $RightPost.global_transform.origin.distance_to(other.global_transform.origin)):
		print(name, "'s left link")
		leftLink = other
		$LeftPost/MeshInstance.visible = true
	else:
		print(name, "'s right link")
		rightLink = other
		$RightPost/MeshInstance2.visible = true
	if isGate:
		gateRef = other
	if other.gateRef != null:
		gateRef = other.gateRef
	if gateRef != null:
		gateRef.search()

func unlink(other, isGate = false):
	print("[Fence] unlinking ", other, " from ", self)
	if other == leftLink:
		leftLink = null
	if other == rightLink:
		rightLink = null
	if gateRef != null:
		gateRef.test_complete()
	if isGate:
		gateRef = null


func _on_SnapZone_area_exited(area):
	if area.get_parent().has_method("unlink"):
		area.get_parent().call("unlink", area.get_parent(), area.get_parent().has_method("is_gate"))
	pass # Replace with function body.
