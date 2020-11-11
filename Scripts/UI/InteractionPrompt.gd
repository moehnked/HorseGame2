extends Control

var buttonText = " (E)"
var screenOffset = ProjectSettings.get_setting("display/window/size/height") * 0.88
var x_window = ProjectSettings.get_setting("display/window/size/width")
var y_window = ProjectSettings.get_setting("display/window/size/height")

func _ready():
	$Label.rect_position.x = (x_window * 0.5) - ($Label.rect_size.x / 2)
	$Label.rect_position.y = (y_window * 0.5) - ($Label.rect_size.y / 2)
	clear()

func clear():
	$Label.visible = false
	
func show_prompt(prompt, low = false):
	if(low):
		$Label.rect_position.y = screenOffset - ($Label.rect_size.y / 2)
	else:
		$Label.rect_position.y = (y_window * 0.5) - ($Label.rect_size.y / 2)
	$Label.text = prompt + buttonText
	$Label.visible = true
	
