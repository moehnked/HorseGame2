extends Area

onready var testPointResource = preload("res://prefabs/Misc/TestPoint.tscn")

var connected_peices = []
var controller = null
var gateRef = self
var interactionPrompt = ""
var isOpen = false
var isInteractable = true
var isComplete:bool = false
var leftLink = null
var midpoint = Vector3()
var midpoint_object = null
var rightLink = null
var number_of_peices = 1

func complete():
	print("COMPLETE CORRAL - ", connected_peices.size())
	var corrals = Global.GCR
	midpoint = corrals.calculate_midpoint(connected_peices)
	midpoint.y = global_transform.origin.y + 3
	midpoint_object = testPointResource.instance()
	midpoint_object.global_transform.origin = midpoint
	Global.world.add_child(midpoint_object)
	midpoint_object.scale = Vector3(1,1,1)
	isComplete = true
	corrals.register(self)
	$isCompleteViewer.visible = true

func get_midpoint():
	return midpoint_object

func get_size():
	return connected_peices.size()

func interact(_controller):
	controller = _controller
	if controller.has_method("read_prompt"):
		controller.read_prompt()
	if controller.has_method("add_to_ignore"):
		controller.add_to_ignore(self)
	toggle()
	$AutoShutTimer.stop()
	if(isOpen):
		$AutoShutTimer.start(6.0)
	pass

func is_gate():
	return true

func link(other):
	print("linking ", other.name," to ->")
	if($LeftPost.global_transform.origin.distance_to(other.global_transform.origin) < $RightPost.global_transform.origin.distance_to(other.global_transform.origin)):
		leftLink = other
		print(name, "'s left link")
	else:
		print(name, "'s right link")
		rightLink = other
	if search():
		complete()

func play_sound():
	$AudioStreamPlayer.stop()
	$AudioStreamPlayer.stream = load("res://sounds/door_open.wav") if isOpen else load("res://sounds/door_close.wav")
	$AudioStreamPlayer.play()
	
func prompt():
	return "close" if isOpen else "open"

func recursive_search(node, prev):
	if(!connected_peices.has(node)):
		connected_peices.append(node)
	
	if(node.rightLink == prev):
		if(node.leftLink == self):
			return true
		elif(node.leftLink != null):
			return recursive_search(node.leftLink, node)
		else:
			return false
	elif(node.leftLink == prev):
		if(node.rightLink == self):
			return true
		elif(node.rightLink != null):
			return recursive_search(node.rightLink, node)
		else:
			return false

func search():
	print("searching...")
	if(leftLink != null):
		return recursive_search(leftLink, self)
	elif(rightLink != null):
		return recursive_search(rightLink, self)
	else:
		return false

func test_complete():
	if search():
		if not isComplete:
			complete()
	else:
		uncomplete()
	pass

func toggle():
	isOpen = not isOpen
	$Open.visible = isOpen
	$Closed.visible = not isOpen
	$Blocker/CollisionShape2.disabled = isOpen
	interactionPrompt = prompt()
	play_sound()

func uncomplete():
	var corrals = Global.GCR
	corrals.unregister(self)
	isComplete = false
	$isCompleteViewer.visible = false
	if midpoint_object != null:
		midpoint_object.queue_free()
		midpoint_object = null

func unlink(other):
	print("unlinking ", other.name)
	if other == leftLink:
		leftLink = null
	if other == rightLink:
		rightLink = null
	if search() and not isComplete:
		complete()
	else:
		uncomplete()
	pass

func _on_Gate_area_entered(area):
	if area.has_method("link"):
		if($LeftPost.global_transform.origin.distance_to(area.global_transform.origin) < $RightPost.global_transform.origin.distance_to(area.global_transform.origin)):
			leftLink = area
		else:
			rightLink = area
		area.link(self, true)
	elif(area.owner != null):
		if area.owner.has_method("link"):
			if($LeftPost.global_transform.origin.distance_to(area.owner.global_transform.origin) < $RightPost.global_transform.origin.distance_to(area.owner.global_transform.origin)):
				leftLink = area.owner
			else:
				rightLink = area.owner
			area.owner.link(self, true)


func _on_AutoShutTimer_timeout():
	toggle()
	pass # Replace with function body.


func _on_Gate_area_exited(area):
	print("[Gate] area_exited: ",area," ",area.name)
	if area.has_method("link"):
		unlink(area)
	else:
		var p = area.get_parent()
		if(p != null):
			if p.has_method("link"):
				unlink(p)
	pass # Replace with function body.


func _on_Gate_body_exited(body):
	print("[Gate] body_exited: ", body, " ", body.name)
	if body.has_method("link"):
		unlink(body)
	else:
		var p = body.get_parent()
		if(p != null):
			if p.has_method("link"):
				unlink(p)
	pass # Replace with function body.
