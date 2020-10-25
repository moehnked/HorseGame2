extends Node2D

var inventoryScreen
var item
var title
onready var sound

func initialize(i, screen, count = 1):
	inventoryScreen = screen
	item = i
	title = item.get_name()
	set_label_names(title, count)

func set_label_names(text, count = 1):
	$Container/Label.text = (text + " X" + String(count)) if (count > 1) else text
	$Container/Label2.text = (text + " X" + String(count)) if (count > 1) else text

func get_height():
	return $Container/TextureButton.rect_size.y * $Container.scale.y
	pass

func play_sound(sfx = "res://sounds/ui_select_01.wav", vol = 0.0):
	$AudioStreamPlayer.volume_db = vol
	$AudioStreamPlayer.stream = load(sfx)
	$AudioStreamPlayer.play()
	

func toggle():
	$Container/off.visible = !$Container/off.visible
	$Container/on.visible = !$Container/on.visible

func _on_TextureButton_mouse_entered():
	inventoryScreen.update_display(item)
	play_sound("res://sounds/ui_select_02.wav", -8)
	toggle()
	pass # Replace with function body.


func _on_TextureButton_mouse_exited():
	inventoryScreen.clear_display()
	toggle()
	pass # Replace with function body.


func _on_TextureButton_button_up():
	play_sound("res://sounds/ui_select_01.wav", -2)
	pass # Replace with function body.
