extends Control

var buttonText = " (E)"
var screenOffset = ProjectSettings.get_setting("display/window/size/height") * 0.88
var x_window = ProjectSettings.get_setting("display/window/size/width")
var y_window = ProjectSettings.get_setting("display/window/size/height")
var fadeCoeff = 0
var fadeScale = 0.03

func _ready():
	Global.InteractionPrompt = self
	$Label.rect_position.x = (x_window * 0.5) - ($Label.rect_size.x / 2)
	$Label.rect_position.y = (y_window * 0.5) - ($Label.rect_size.y / 2)
	clear()

func _process(delta):
	$Context.percent_visible = clamp($Context.percent_visible + (fadeScale * fadeCoeff), 0.0, 1.0)
	var alpha = $ColorRect.modulate.a + (fadeScale * fadeCoeff)
	alpha = clamp(alpha, 0.0, 1.0)
	$ColorRect.modulate = Color(1,1,1,alpha)
	$Label2.rect_position = $Label.rect_position + Vector2(3,2)
	$Label2.text = $Label.text
	$Label2.visible = $Label.visible

func clear():
	$Label.visible = false
	$Crosshair.visible = true

func hide_context():
	fadeCoeff = -1

func show_prompt(prompt, low = false, showButtonPrompt = true):
	$Crosshair.visible = false
	if(low):
		$Label.rect_position.y = screenOffset - ($Label.rect_size.y / 2)
	else:
		$Label.rect_position.y = (y_window * 0.5) - ($Label.rect_size.y / 2)
	$Label.text = prompt + (buttonText if showButtonPrompt else "")
	$Label.visible = true

func show_context(text):
	$Context.text = text
	$Context.percent_visible = 0.0
	fadeCoeff = 1
	$ContextTimer.start(3)

func _on_ContextTimer_timeout():
	hide_context()
	pass # Replace with function body.
