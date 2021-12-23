#ItemContext_Button
extends TextureButton

export var text = "BUTTON"

var item
var controller

signal emit_pressed(item)

func disable():
	disabled = true
	visible = false

func enable():
	disabled = false
	visible = true

func initialize(args = {}):
	args = Utils.check(args, {"item":null, "controller":null, "text":""})
	item = args.item
	controller = args.controller
	set_text(args.text if args.text != "" else text)
	enable()

func set_text(t = text):
	$Label.text = text

func press():
	print("press context button: ", text)
	emit_signal("emit_pressed", item)


func _on_TextureButton_button_down():
	#release_focus()
	pass # Replace with function body.


func _on_TextureButton_button_up():
	press()
	#grab_focus()
	pass # Replace with function body.
