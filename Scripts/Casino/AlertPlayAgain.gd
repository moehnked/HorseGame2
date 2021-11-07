extends "res://Scripts/Casino/GameUI.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func close_out():
	var n = load("res://prefabs/Casino/CardGames/TransitionExit.tscn").instance()
	instantiate(n)

func show_mouse():
	Utils.show_mouse()
	Input.set_custom_mouse_cursor(null)


func _on_YES_pressed():
	print("play again")
	Global.AudioManager.play_sound("res://Sounds/jrpgUI/Purchase.wav", -5)
	#call_game_method("restart_game")
	$AnimationPlayer.play("exit")
	pass # Replace with function body.


func _on_YES_mouse_entered():
	Global.AudioManager.play_sound("res://Sounds/jrpgUI/Open.wav", -5)
	$YES/yeslabel.visible = true
	pass # Replace with function body.


func _on_YES_mouse_exited():
	$YES/yeslabel.visible = false
	pass # Replace with function body.


func _on_No_mouse_entered():
	Global.AudioManager.play_sound("res://Sounds/jrpgUI/Close.wav", -5)
	$No/nolabel.visible = true
	pass # Replace with function body.


func _on_No_mouse_exited():
	$No/nolabel.visible = false
	pass # Replace with function body.


func _on_No_pressed():
	print("quit")
	close_out()
	pass # Replace with function body.
