extends Spatial

var slot_game_res = "res://prefabs/UI/Misc/SlotsGame.tscn"

var active_game_ref
var player_ref

func _on_Interactable_interaction(controller):
	#print(controller.get_parent())
	player_ref = controller.get_parent()
	if player_ref.chips > 0:
		player_ref.enter_some_menu()
		active_game_ref = Global.world.instantiate(slot_game_res)
		active_game_ref.connect("emit_score", self, "game_over")
		active_game_ref.initialize(player_ref, self)
	else:
		Global.InteractionPrompt.show_context("You need chips in order to play!")
	pass # Replace with function body.

func cancel():
	active_game_ref.disconnect("emit_score", self, "game_over")
	player_ref.exit_some_menu()
	active_game_ref = null

func game_over(score, wager):
	$slotmachine/music_loop.stop()
	$slotmachine/music_end.play()
	if score < 0:
		$slotmachine/failure.play()
		player_ref.chips -= wager
	else:
		$slotmachine/AnimationPlayer.play("Payout")
		player_ref.chips += wager * score
	player_ref.exit_some_menu()
	pass

func pull():
	$slotmachine/AnimationPlayer.play("Arm")
	$slotmachine/music_loop.play()
