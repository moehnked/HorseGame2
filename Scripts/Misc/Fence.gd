extends StaticBody

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
