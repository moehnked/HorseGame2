extends Area2D

var mouseOver = false

signal emit_clicked()

func _on_Clickable_mouse_entered():
	print("mouse exit")
	mouseOver = true
	pass # Replace with function body.


func _on_Clickable_mouse_exited():
	print("mouse exit")
	mouseOver = false
	pass # Replace with function body.


func _input(event):
	if event.is_action_released("standard") and mouseOver:
		emit_signal("emit_clicked")
