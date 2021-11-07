extends "res://Scripts/Casino/PlaceYourBets.gd"


func initialize(playerWon):
	if playerWon:
		$AnimationPlayer.play("victory")
	else:
		$AnimationPlayer.play("lose")
		pass

func check_chips():
	if Global.Player.chips > 0:
		call_game_method("alert_play_again")
		queue_free()
	else:
		$AnimationPlayer.play("Busted")

func close_out():
	var n = load("res://prefabs/Casino/CardGames/TransitionExit.tscn").instance()
	instantiate(n)
