extends "res://Scripts/Horse/Horse.gd"


export(Array, Resource) var options
export(String) var dialogueTimelineName = "emptyDialogue"
export(int) var dialoguePoint = 1
export(Resource) var icon
export(Array, Resource) var talkSounds
export(float, -20,5) var speakingVolume = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_icon():
	return icon

func get_options(removeExits = false):
	print("horseNPC: getting options ", removeExits)
	var o = options
#	if removeExits:
#		print("horseNPC - ", o)
#		for i in o:
#			print("horseNPC: i - ", i.resource_name, " -p- ", i.resource_path)
#			if i.resource_name == "Exit":
#				print("Erasing ", i.name)
#				o.erase(i)
#		#remove_exits_by_name("Exit")
	return o

func get_dialogue_point():
	#return dialogueTimelineName
	#
	return get_horse_name() + "/" + (("0" + String(dialoguePoint)) if dialoguePoint < 10 else String(dialoguePoint))

func get_speaking_volume():
	return speakingVolume
	pass

func get_talk_sfx():
	return talkSounds[Global.world.rng.randi() % talkSounds.size()].resource_path

func increment_timeline():
	print("-=-=-=-= INCREMENTING dialogue point")
	dialoguePoint += 1
	pass
	
func set_options(nextOptions):
	options = nextOptions
	options.append(load("res://prefabs/UI/Dialogue/Exit.tscn"))
