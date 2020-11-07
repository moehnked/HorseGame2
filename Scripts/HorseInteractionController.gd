extends Area
const hm = preload("res://Scripts/Statics/HorseMoods.gd")
const HorseMoods = hm.HorseMoods

export var baby_threshold = 100
var horses = []
var intented_talki = null
var interactionPrompt = "Talk"
var isInteractable = true

func determine_horse_source(area):
	if(area.has_method("is_horse_interaction_controller") and area != owner):
		return area.owner
	elif(area.owner != null):
		if(area.owner == owner):
			return null
		elif(area.owner.has_method("is_horse_interaction_controller")):
			return area.owner
	else:
		return null

func determine_interaction(other):
	print("determinting if other is horse for interatction: ", other.has_method("is_horse"))
	if(other.check_relationships(owner) >= baby_threshold):
		print("havin a good time havin a good time")
		other.validate_reproduction(owner)
		horses.erase(other)
	if other.pep >= 10:
		print("im gonna talk to my buddy ", other.name)
		other.recieve_charm(hm.random_mood(), owner)

func interact(controller):
	owner.recieve_charm(hm.random_mood(), controller.owner)

func is_horse_interaction_controller():
	return true

func prompt():
	return interactionPrompt

func _on_HorseInteractionController_area_entered(area):
	#var h = determine_horse_source(area)
	var h = area.owner if area.has_method("is_horse_interaction_controller") else null
	#print("========= h is ", h)
	if(h != null):
		print("I'm close enough to talk to ", h.name)
		if !horses.has(h):
			horses.append(h)
			if(h == intented_talki):
				print("queing ", h.name, " to interact queue...")
				owner.enter_talk_state()



func _on_HorseInteractionController_area_exited(area):
	#var h = determine_horse_source(area)
	var h = area.owner if area.has_method("is_horse_interaction_controller") else null
	print("========= h is ", h)
	if(h != null):
		if(horses.has(h)):
			horses.erase(h)
