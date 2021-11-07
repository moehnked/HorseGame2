extends Control

var horseRef
var horseName = "horse"

signal clicked(selection)

func set_name_label(n):
	horseName = n
	$Label.text = horseName

func set_ref(r):
	horseRef = r


func _on_TextureButton_pressed():
	print("ButcherOption: ", horseName , " chosen")
	emit_signal("clicked", horseRef)
	pass # Replace with function body.
