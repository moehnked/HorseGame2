extends Area

var connected_peices = []
var gateRef = self
var interactionPrompt = ""
var isOpen = false
var isInteractable = true
var leftLink = null
var rightLink = null
var number_of_peices = 1


func complete():
	print("COMPLETE CORRAL - ", connected_peices.size())
	var corrals = get_tree().get_root().get_node("World").get_node("GlobalCorralRegistrar")
	corrals.register(self)

func get_size():
	return connected_peices.size()

func interact(controller):
	isOpen = not isOpen
	$Open.visible = isOpen
	$Closed.visible = not isOpen
	$Blocker/CollisionShape2.disabled = isOpen
	interactionPrompt = prompt()
	controller.read_prompt()
	play_sound()
	pass

func link(other):
	print("linking ", other.name," to ->")
	if($LeftPost.global_transform.origin.distance_to(other.global_transform.origin) < $RightPost.global_transform.origin.distance_to(other.global_transform.origin)):
		leftLink = other
		print(name, "'s left link")
	else:
		print(name, "'s right link")
		rightLink = other
	#connected_peices.append(other)
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

#func search():
#	if(rightLink != null):
#		var tmp = rightLink
#		var prev = self
#		var links = 1
#		while(tmp != self and tmp != null):
#			#case 1 we are attached to tmp's right
#			if(tmp.rightLink == prev):
#				prev = tmp
#				tmp = tmp.leftLink
#				links += 1
#			#case 2 we are attached to tmp's left
#			elif(tmp.leftLink == prev):
#				prev = tmp
#				tmp = tmp.rightLink
#				links += 1
#		print("number of fence peices: ", links)
#		number_of_peices = links
#		if tmp == self:
#			return true
#		else:
#			tmp = leftLink
#			prev = self
#			links = 1
#			while(tmp != self and tmp != null):
#				#case 1 we are attached to tmp's right
#				if(tmp.rightLink == prev):
#					prev = tmp
#					tmp = tmp.leftLink
#					links += 1
#				#case 2 we are attached to tmp's left
#				elif(tmp.leftLink == prev):
#					prev = tmp
#					tmp = tmp.rightLink
#					links += 1
#			if tmp == self:
#				return true
#			else:
#				return false

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
