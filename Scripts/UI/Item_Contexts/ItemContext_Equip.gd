extends Control

var item
var controller

func initialize(args = {}):
	args = Utils.check(args, {"item":load("res://prefabs/Items/Equipable.tscn").instance(), "controller":null})
	item = args.item
	controller = args.controller

func _on_TextureButton_button_up():
	item.equip(controller)
	pass # Replace with function body.
