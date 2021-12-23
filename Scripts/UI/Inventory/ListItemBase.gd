extends TextureButton

signal emit_selected(item, count)
signal emit_focus_entered(item)

var item
var count

func gain_focus():
	Global.AudioManager.play_sound("res://Sounds/UI_Select_B.wav")
	emit_signal("emit_focus_entered", item)

func set_count(c):
	count = c
	update_text()

func set_item(i):
	item = i

func selection_sound():
	Global.AudioManager.play_sound("res://Sounds/UI_Select_A.wav")
	emit_signal("emit_selected", item, count)

func update_text():
	$Label.text = item.get_name() + ("                 x" + String(count) if count > 1 else "")

func _on_ListItem_mouse_entered():
	if not has_focus():
		gain_focus()
	pass # Replace with function body.


func _on_ListItem_mouse_exited():
	#Global.world.get_tree().call_group("InvScreen", "draw_selected_icon")
	pass # Replace with function body.
