extends Node2D

var inventoryScreen
var item
var title
onready var sound

export(Dictionary) var sfx

func initialize(i, screen, count = 1):
	print(self, ":initializing ", i)
	inventoryScreen = screen
	item = i
	title = item.get_name()
	set_label_names(title, count)

func set_label_names(text, count = 1):
	$Container/Label.text = (text + " X" + String(count)) if (count > 1) else text
	$Container/Label2.text = (text + " X" + String(count)) if (count > 1) else text

func set_opacity(val):
	val = clamp(val, 0, 1)
	$Container.modulate = Color(1,1,1,val)

func get_height():
	return $Container/TextureButton.rect_size.y * $Container.scale.y
	pass

func play_sound(s = "select1", vol = 0.0):
	Global.AudioManager.play_sound(sfx[s], vol)

func toggle():
	$Container/off.visible = !$Container/off.visible
	$Container/on.visible = !$Container/on.visible

func _on_TextureButton_mouse_entered():
	inventoryScreen.update_display(item)
	play_sound("select2", -8)
	toggle()
	pass # Replace with function body.


func _on_TextureButton_mouse_exited():
	inventoryScreen.clear_display()
	toggle()
	pass # Replace with function body.


func _on_TextureButton_button_up():
	play_sound("select1", -2)
	inventoryScreen.draw_context(item)
	pass # Replace with function body.
