extends "res://Scripts/Horse/Horse.gd"

#export(String) var dialogueTimelineName = "emptyDialogue"
export(int) var dialoguePoint = 1
export(Resource) var icon
export(Array, Resource) var talkSounds
export(float, -20,5) var speakingVolume = 0.0
export(Dictionary) var questItems = {}

func append_quest_item(itemName, quant):
	questItems[itemName] = quant

func get_icon():
	return icon

func get_dialogue_point():
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
