extends Control

var buttonMode = 1
var buttonText = " (E)"
var screenOffset = ProjectSettings.get_setting("display/window/size/height") * 0.88
var x_window = ProjectSettings.get_setting("display/window/size/width")
var y_window = ProjectSettings.get_setting("display/window/size/height")
var fadeCoeff = 0
var fadeScale = 0.03
var isFadingMusic = false
var isHidden = false


func _ready():
	Global.InteractionPrompt = self
	$Label.rect_position.x = (x_window * 0.5) - ($Label.rect_size.x / 2)
	$Label.rect_position.y = (y_window * 0.5) - ($Label.rect_size.y / 2)
	clear()

func _input(event):
	if(event is InputEventKey):
		# Do stuff
		set_button_display(0)
	elif(event is InputEventJoypadButton or event is InputEventJoypadMotion):
		set_button_display(1)
		# Do stuff

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
	$Label2.visible = false
	$Crosshair.visible = true
	hide_button_hint()

func hide_button_hint():
	$ButtonHintContainer.visible = false

func hide_context():
	fadeCoeff = -1
	if isFadingMusic:
		isFadingMusic = false
		Global.AudioManager.fade_music(0, 0.1, true)

func hide_center_prompt():
	$Label.visible = false
	$Label2.visible = false
	isHidden = true
	hide_button_hint()

func set_button_display(mode = 0):
	buttonMode = mode
	match mode:
		0:
			$ButtonHintContainer/ButtonHintKeys.visible = true
			$ButtonHintContainer/ButtonHintCont.visible = false
			pass
		1:
			$ButtonHintContainer/ButtonHintKeys.visible = false
			$ButtonHintContainer/ButtonHintCont.visible = true
			pass

func show_button_prompt():
	$ButtonHintContainer.visible = true
	pass

func show_context(text, dimMusicWhile = false):
	$Context.text = text
	$Context.percent_visible = 0.0
	fadeCoeff = 1
	$ContextTimer.start(3)
	isFadingMusic = dimMusicWhile
	if isFadingMusic:
		Global.AudioManager.fade_music(Global.AudioManager.get_current_music_volume() - 10, 0.1)

func show_prompt(prompt, low = false, showButtonPrompt = true):
	$Crosshair.visible = false
	if(low):
		$Label.rect_position.y = screenOffset - ($Label.rect_size.y / 2)
	else:
		$Label.rect_position.y = (y_window * 0.5) - ($Label.rect_size.y / 2)
	#$Label.text = prompt + (buttonText if showButtonPrompt else "")
	$Label.text = prompt
	if showButtonPrompt:
		show_button_prompt()
	$Label.visible = (true and not isHidden)

func unhide_center_prompt():
	$Label.visible = true
	$Label2.visible = true
	isHidden = false
	
func _on_ContextTimer_timeout():
	hide_context()
	pass # Replace with function body.
