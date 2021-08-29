extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.StatusPrompt = self
	$ProgressBar.modulate.a = 0.0
	pass # Replace with function body.

func _process(delta):
	$ProgressBar.modulate.a = max($ProgressBar.modulate.a - 0.01, 0)

func update_status(current, top):
	$ProgressBar.max_value = top
	$ProgressBar.value = current
	$ProgressBar.modulate.a = 1.0
