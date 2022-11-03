extends TextureButton

export(Resource) var JournalMenuRef

signal emit_selected(listItem)
signal emit_focus(button)


func _process(delta):
	if Input.is_action_just_released("ui_accept") and has_focus():
		press()

func enter_focus():
	print("Journal list item mouse entered!")
	emit_signal("emit_focus", self)
	Global.AudioManager.play_sound("res://Sounds/UI_Close_03.wav")
	press()
	pass # Replace with function body.


func exit_focus():
	print("Journal list item mouse exited")
	$AnimatedSprite.play("default")
	pass # Replace with function body.

func get_journal():
	return JournalMenuRef

func mouse_enter():
	Global.AudioManager.play_sound("res://Sounds/UI_Select_A.wav")
	pass

func mouse_exit():
	release_focus()
	pass

func press():
	emit_signal("emit_selected", self)

