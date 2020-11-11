extends Area
const hm = preload("res://Scripts/Statics/HorseMoods.gd")
const HorseMoods = hm.HorseMoods
const RSG = preload("res://Scripts/Statics/RSG.gd")

export var baby_threshold = 100
var horses = []
var interactionPrompt = "Talk"
var isInteractable = true
var notAllowedToInteractWith = []

func debug_births(other):
	if(other.readyToHaveKids):
		other.readyToHaveKids = false
		print("havin a debug time havin a debug time")
		other.validate_reproduction(owner)
		horses.erase(other)

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
	debug_births(other)
	if(other.check_relationships(owner) >= baby_threshold):
		print("havin a good time havin a good time")
		other.validate_reproduction(owner)
		horses.erase(other)
	if other.pep >= 10:
		print("im gonna talk to my buddy ", other.name)
		return other.recieve_charm(hm.random_mood(), owner)

func get_inventory():
	return null

func interact(controller):
	print(RSG.generate_sentance())
	owner.recieve_charm(hm.random_mood(), controller.owner)

func is_horse_interaction_controller():
	return true

func prompt():
	return interactionPrompt

func read_prompt():
	pass

func _on_HorseInteractionController_area_entered(area):
	#var h = determine_horse_source(area)
	var h = area.owner if area.has_method("is_horse_interaction_controller") else null
	#print("========= h is ", h)
	if(h != null):
		print("I'm close enough to talk to ", h.name, "  -- state : ", h.get_state())
		if !horses.has(h) and ['idle', 'wander', 'none', 'walking', 'talking'].has(h.get_state()):
			horses.append(h)
			if(h == owner.walk_to_target):
				print("queing ", h.name, " to interact queue...")
				owner.enter_talk_state()
	else:
		#var i = area if (area.has_method("interact")) else if()
		if(area.has_method("interact")) and !notAllowedToInteractWith.has(area):
			#print("=-=- I ",("am " if(!notAllowedToInteractWith.has(area)) else "am not "), "allowed to interact with ", area.name)
			area.interact(self)
			if area.has_method("is_gate"):
				notAllowedToInteractWith.append(area)



func _on_HorseInteractionController_area_exited(area):
	#var h = determine_horse_source(area)
	var h = area.owner if area.has_method("is_horse_interaction_controller") else null
	#print("========= h is ", h)
	if(h != null):
		if(horses.has(h)):
			horses.erase(h)
