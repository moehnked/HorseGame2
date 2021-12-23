extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	set_button_display(Global.InteractionPrompt.buttonMode)
	pass

func set_button_display(mode = 0):
	match mode:
		0:
			$ButtonHintKeys.visible = true
			$ButtonHintCont.visible = false
			pass
		1:
			$ButtonHintKeys.visible = false
			$ButtonHintCont.visible = true
			pass
	pass
