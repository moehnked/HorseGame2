extends Area
const hm = preload("res://Scripts/Statics/HorseMoods.gd")
const HorseMoods = hm.HorseMoods
const RSG = preload("res://Scripts/Statics/RSG.gd")

export var baby_threshold = 100
var equipped = null
var horses = []
var interactionPrompt = "Talk"
var interactEnabled = true
var inventory = []
var isInteractable = true
var notAllowedToInteractWith = []

func create_dialogue(controller):
	var o = load("res://Scripts/UI/DialogueScreen.tscn").instance()
	add_child(o)
	owner.begin_dialogue(controller)
	controller.begin_dialogue(owner)
	o.initialize({'speaker':owner, 'text':RSG.generate_sentance(), 'listener':controller.owner})

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

func disable_interaction():
	isInteractable = false

func enable_interact():
	isInteractable = true

func equip(item):
	disable_interaction()
	item.parent_transform = owner.get_palm()
	equipped = item
	pass

func get_inventory():
	return inventory

func interact(controller):
	#print(RSG.generate_sentance())
	if(isInteractable):
		if(owner.pep >= 5):
			create_dialogue(controller)
		elif owner.pep >= -4:
			owner.recieve_charm(hm.random_mood(), controller.owner)

func is_horse_interaction_controller():
	return true

func prompt():
	return interactionPrompt

func read_prompt():
	pass

func start_interaction_colldown():
	owner.get_node("InteractabilityTimer").start()

func throw_equipped():
	if(equipped != null):
		print("equipped")
		if(equipped.has_method("shoot_basket")):
			print("shooting")
			equipped.shoot_basket()

func _on_HorseInteractionController_area_entered(area):
	#var h = determine_horse_source(area)
	var h = area.owner if area.has_method("is_horse_interaction_controller") else null
	#print("========= h is ", h)
	if(h != null):
		print("I'm close enough to talk to ", h.name, "  -- state : ", h.get_state())
#		if !horses.has(h) and ['idle', 'wander', 'none', 'walking', 'talking'].has(h.get_state()):
#			horses.append(h)
#			if(h == owner.walk_to_target):
#				print("queing ", h.name, " to interact queue...")
#				owner.enter_talk_state()
	else:
		#var i = area if (area.has_method("interact")) else if()
		if(area.has_method("interact")) and !notAllowedToInteractWith.has(area) and interactEnabled:
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


func _on_InteractabilityTimer_timeout():
	enable_interact()
	pass # Replace with function body.
