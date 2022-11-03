extends TextureButton

var questID

signal emit_pressed(questID)

func _ready():
	$container.modulate = Color(1,1,1,0)

func _on_QuestlineOption_pressed():
	emit_signal("emit_pressed", questID)
	Global.AudioManager.play_sound("res://Sounds/UI_Select_A.wav")
	pass # Replace with function body.


func _on_QuestlineOption_mouse_entered():
	print(questID)
	Global.AudioManager.play_sound("res://Sounds/UI_Select_B.wav")
	$container/Label.text = Global.QuestJournal.get_quest_name(questID)
	$AnimationPlayer.play("show")
	pass # Replace with function body.


func _on_QuestlineOption_mouse_exited():
	$container.modulate = Color(1,1,1,0)
	$AnimationPlayer.stop()
	pass # Replace with function body.
