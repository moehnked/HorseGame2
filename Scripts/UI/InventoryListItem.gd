extends Node2D

var inventoryScreen
var item
var title

func initialize(i, screen):
	inventoryScreen = screen
	item = i
	title = item.get_name()
	set_label_names(title)

func set_label_names(text, count = 1):
	$Container/Label.text = (text + " X" + String(count)) if (count > 1) else text
	$Container/Label2.text = (text + " X" + String(count)) if (count > 1) else text

func get_height():
	return $Container/TextureButton.rect_size.y * $Container.scale.y
	pass


func _on_TextureButton_mouse_entered():
	inventoryScreen.update_display(item)
	pass # Replace with function body.


func _on_TextureButton_mouse_exited():
	inventoryScreen.clear_display()
	pass # Replace with function body.
