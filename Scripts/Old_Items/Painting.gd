extends "res://Scripts/Item.gd"
export var painting_desc = ""

func interact(controller):
	print("Artwork by Kylee Martell...")

func is_low():
	return true

func prompt():
	return painting_desc

