extends "res://Scripts/Horse/HorseNPC.gd"


func get_dialogue_point():
	return "Generic/" + (("0" + String(dialoguePoint)) if dialoguePoint < 10 else String(dialoguePoint))
