#ItemContext_Button
extends Control

export var text = "BUTTON"

signal pressed()

var item
var controller

func disable():
	$TextureButton.disabled = true
	visible = false

func enable():
	$TextureButton.disabled = false
	visible = true

func initialize(args = {}):
	args = Utils.check(args, {"item":load("res://prefabs/Items/Equipable.tscn").instance(), "controller":null, "text":""})
	item = args.item
	controller = args.controller
	set_text(args.text if args.text != "" else text)
	enable()

func press():
	emit_signal("pressed")

func set_text(t = text):
	text = t
	$Label.text = text
	$Label2.text = text

func _on_TextureButton_button_up():
	press()
	pass # Replace with function body.
