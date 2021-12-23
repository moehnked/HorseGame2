extends "res://Scripts/Objects/Sign.gd"

export(Resource) var display
var readRef = preload("res://prefabs/UI/Misc/SignReads/SignReadScreen.tscn")

func create_read_ui(controller):
	Global.world.instantiate(readRef).add_child(display.instance())
	pass
