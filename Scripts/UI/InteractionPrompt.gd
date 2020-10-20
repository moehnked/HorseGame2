extends Control

var buttonText = " (E)"

func _ready():
	clear()

func clear():
	$Label.visible = false
	
func show_prompt(prompt):
	$Label.text = prompt + buttonText
	$Label.visible = true
	
