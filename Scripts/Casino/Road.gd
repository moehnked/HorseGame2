extends Control

export(Resource) var cardResource
export(Resource) var emptyCursor

var bet = 1
var betButtonAmount = 1
var betRounds = 0
var burn
var bumpables = []
var cardsInPlay = []
var chips = 100
var deck = range(0, 52)
var discard = []
var discardSelection
var hand = []
var jackHand = []
var jackRank = 0
var jackHighCard = 0
var playerRank = 0
var playerHighCard = 0
var road = []
var roadRemaining = 3
var wager = 0
var wagerDifference = 0

func _ready():
	initialize()
	

func alert_bet(amount):
	var o = load("res://prefabs/Casino/CardGames/WagerIncreaseAlert.tscn").instance()
	$Container/UIContainer/WagerLabel.add_child(o)
	o.position.y += 30
	o.initialize(amount)

func alert_game_over():
	jack_evaluate()
	evaluate_hands()
	var c = get_winner()
	var o = load("res://prefabs/Casino/CardGames/AlertGameOver.tscn").instance()
	$CenterUiPosition.add_child(o)
	o.initialize(c)
	print("game over ", chips, ", ", Global.Player.chips, " - ", wager, " |", wagerDifference)
	Global.Player.chips = chips + (wager if c  else 0)

func alert_game_reset():
	var o = load("res://prefabs/Casino/CardGames/AlertGameReset.tscn").instance()
	add_child(o)

func alert_place_your_bets():
	var o = load("res://prefabs/Casino/CardGames/PlaceYourBets.tscn").instance()
	$CenterUiPosition.add_child(o)

func alert_play_again():
	var o = load("res://prefabs/Casino/CardGames/AlertPlayAgain.tscn").instance()
	$CenterUiPosition.add_child(o)

func alert_player_turn():
	var o = load("res://prefabs/Casino/CardGames/AlertPlayerTurn.tscn").instance()
	$CenterUiPosition.add_child(o)
	#var p = load("res://prefabs/UI/Misc/CustomMouseCursor.tscn").instance()
	#$CenterUiPosition.add_child(p)

func alert_show_em():
	disable_ui_input()
	var o = load("res://prefabs/Casino/CardGames/AlertShowEm.tscn").instance()
	$CenterUiPosition.add_child(o)

func call_or_pass():
	pass

func continue_betting():
	if wagerDifference != 0:
		show_mouse()
		update_ui_container(true)
		update_ui_raise_call(true)
		update_ui_betting(true)
	else:
		alert_place_your_bets()

func create_card(pos, sca, rot):
	var c = cardResource.instance()
	$Container.add_child(c)
	c.set_card(pull_random_card())
	c.scale = Vector2(.01,.01)
	c.set_deal_to(pos, sca, rot)
	return c

func deal_card(carDealt, startPos):
	match carDealt:
		1:
			var c = create_card($Container/Hand/Hand1.global_position, Vector2(0.5,0.5), 360)
			c.position = startPos
			cardsInPlay.append(c)
			hand.append(c)
		2, 3:
			var c = create_card(get_node("Container/Hand/Hand" + (String(carDealt))).global_position, Vector2(0.5,0.5), 360)
			c.position = startPos
			cardsInPlay[carDealt - 2].flip()
			cardsInPlay.append(c)
			hand.append(c)
		4, 5, 6:
			if carDealt == 4:
				cardsInPlay[carDealt - 2].flip()
			var c = create_card(get_node("Container/TheRoad/" + String(carDealt)).global_position,Vector2(0.3,0.3), 360)
			c.position = startPos
			cardsInPlay.append(c)
			road.append(c)
			if carDealt == 6:
				$Container/Deck.visible = true
				burn = create_card($Container/Deck.global_position, Vector2(0.3,0.3), 0)
				burn.global_position = $Container/Deck.global_position
				burn.flip()
				deal_jack()
				alert_place_your_bets()
	pass

func deal_jack():
	for i in range(3):
		var c = create_card($Container.global_position, Vector2.ZERO, 0)
		jackHand.append(c)

func disable_ui_input():
	$ButtonRoad.disabled = true
	$ButtonRoad.visible = false
	$BurnButton.disabled = true
	$BurnButton.visible = false
	$DiscardButton.disabled = true
	$DiscardButton.visible = false
	$Container/UIContainer.visible = false
	for c in hand:
		c.isSelectable = false
	burn.isSelectable = false
	hide_pointer()
	Utils.capture_mouse()

func end_betting():
	update_ui_betting(false)
	update_ui_skip_bet(false)
	update_ui_raise_call(false)
	#jack_start_turn()
	#start_turn()

func end_thinking():
	#jack_start_turn()
	jack_start_betting()

func end_turn():
	print("ending player turn")
	betRounds = 0
	disable_ui_input()
	jack_start_turn()
	#jack_think()
	


func evaluate_hands():
	var eval = CardHandEvaluator.new()
	var gamehand = []
	for c in hand:
		gamehand.append(c)
	if discard.size() > 0:
		gamehand.append(discard.back())
	gamehand.append(burn)
	for x in road:
		gamehand.append(x)
	eval.initialize(gamehand)
	var handRank = eval.evaluate_self()
	print("player best hand: ", handRank," ", eval.get_rank_as_string(handRank))
	for h in gamehand:
		print(h.value, " of ", h.get_suite_shorthand())
		playerHighCard = max(playerHighCard, h.value)
	playerRank = handRank

func exchange_burn_for_hand(card):
	play_sound("res://Sounds/Audio/confirmation_002.ogg", -10)
	for c in hand:
		c.isSelectable = false
	discardSelection.play_animation("default")
	discardSelection.set_deal_to($Container/Discard.global_position, Vector2(0.3,0.3), 360)
	discardSelection.disconnect("emit_clicked", self, "start_discard")
	burn.play_animation("default")
	burn.isSelectable = false
	burn.disconnect("emit_clicked", self, "exchange_burn_for_hand")
	burn.set_deal_to(discardSelection.global_position, Vector2(0.5,0.5), 0)
	hand.erase(discardSelection)
	if discard.size() > 0:
		discardSelection.z_index = discard.back().z_index + 1
	discard.append(discardSelection)
	hand.append(burn)
	burn = create_card($Container/Deck.global_position, Vector2(0.3,0.3), 0)
	burn.global_position = $Container/Deck.global_position
	burn.flip()
	end_turn()

func get_winner():
	if playerRank == jackRank:
		print("tie rank, high card wins")
		return playerHighCard > jackHighCard
	return playerRank > jackRank

func hide_pointer():
	Input.set_custom_mouse_cursor(null)
	$Container/Pointer.visible = false

func initialize():
	chips = Global.Player.chips
	update_ui_container(false)
	update_ui_betting(false)
	update_ui_raise_call(false)
	update_ui_skip_bet(false)
	update_chips_ui()
	update_wager_ui()

func jack_bet():
	update_ui_container(false)
	betRounds += 1
	if wagerDifference != 0:
		#determine call or raise
		print("Jack will call: ", wagerDifference)
		wager += wagerDifference
		alert_bet( wagerDifference)
		wagerDifference = 0
		alert_player_turn()
		#start_turn()
	elif jackRank * 10 > wager:
		var b = min(Global.world.rng.randi_range(1,25), chips)
		print("Jack will bet ", b)
		wagerDifference = b
		wager += wagerDifference
		alert_bet(wagerDifference)
		continue_betting()
	else:
		print("Jack will check - ", betRounds)
		play_sound("res://Sounds/Audio/minimize_008.ogg")
		wagerDifference = 0
		if betRounds <= 1:
			continue_betting()
		else:
			alert_player_turn()
	update_wager_ui()
	pass

func jack_end_turn():
	play_sound("res://Sounds/Audio/minimize_006.ogg", -2)
	var timer = Timer.new()
	Global.world.queue_timer(self, 1, "alert_place_your_bets")

func jack_evaluate(jh = jackHand, useBurn = true, useDiscard = true):
	var eval = CardHandEvaluator.new()
	var jhand = []
	for c in jh:
		jhand.append(c)
	if discard.size() > 0 and useDiscard:
		jhand.append(discard.back())
	if useBurn:
		jhand.append(burn)
	for x in road:
		jhand.append(x)
	
	#print("~ ", jhand)
	eval.initialize(jhand)
	for c in jhand:
		jackHighCard = max(jackHighCard, c.value)
	jackRank = eval.evaluate_self()
	#print("Jack hand: ", jackRank," ", eval.get_rank_as_string(jackRank))
	#print("jack cards: ", jh)
	#print("jack playable: ", jhand)
	return jackRank

func jack_start_turn():
	print("Jack starting turn")
	Global.world.get_tree().call_group("SweetHandJack", "start_turn")
	

func jack_swap_burn(card):
	card.set_deal_to($Container/Discard.global_position, Vector2(0.3,0.3), 360)
	if card.isFlipped:
		card.flip()
	burn.set_deal_to($JackHandContainer.position, Vector2.ZERO, 0)
	jackHand.erase(card)
	jackHand.append(burn)
	if discard.size() > 0:
		card.z_index = discard.back().z_index + 1
	discard.append(card)
	burn = create_card($Container/Deck.global_position, Vector2(0.3,0.3), 0)
	burn.global_position = $Container/Deck.global_position
	burn.flip()
	
func jack_swap_discard(card):
	card.set_deal_to($Container/Discard.global_position, Vector2(0.3,0.3), 360)
	if card.isFlipped:
		card.flip()
	discard.back().set_deal_to($JackHandContainer.position, Vector2.ZERO, 0)
	jackHand.erase(card)
	jackHand.append(discard.back())
	card.z_index = discard.back().z_index + 1
	discard.append(card)

func jack_start_betting():
	jack_evaluate()
	jack_bet()


func jack_take_turn():
	print("Jack will make his move!")
	var curscore = jack_evaluate(jackHand, false, false)
	#{ [card in hand to swap with, card to swap with] : score of move } 
	var moves = {}
	for c in jackHand:
		print("~~ jack evaluating potentially swapping out ", c)
		var h = jackHand.duplicate(true)
		h.erase(c)
		h.append(burn)
		var scoreB = jack_evaluate(h, false, false)
		if discard.size() > 0:
			h.pop_back()
			h.append(discard.back())
			var scoreC = jack_evaluate(h, false, false)
			if scoreB > scoreC:
				moves[c] = [burn, scoreB]
			else:
				moves[c] = [discard.back(), scoreC]
		else:
			moves[c] = [burn, scoreB]
	var z = 0
	var k = null
	for m in moves.keys():
		if moves[m].back() > z:
			z = moves[m].back()
			k = m
	
	if z > curscore:
		if (moves[k].front().cardID == burn.cardID):
			print("jack will swap ", k, " for burn",": ",moves[k].front())
			jack_swap_burn(k)
		else:
			print("jack will swap ", k, " for discard",": ",moves[k].front())
			jack_swap_discard(k)
	else:
		print("jacks current hand is best: ", curscore, " > ", moves[k].front(), ", ", z)
		turn_one()
	if roadRemaining > 0:
		jack_end_turn()
	else:
		Global.world.queue_timer(self, 0.5, "alert_show_em")
		#alert_show_em()


func jack_think():
	Global.world.get_tree().call_group("SweetHandJack", "start_thinking")

func place_bet():
	alert_bet(min(wagerDifference, chips))
	chips -= min(wagerDifference, chips)
	update_chips_ui()
	update_wager_ui()
	end_betting()
	#jack_think()
	betRounds += 1

func play_sound(soundpath, db = 0.0, pitch = 1.0):
	Global.AudioManager.play_sound(soundpath, db, pitch)

func pull_random_card():
	var c = deck[Global.world.rng.randi() % deck.size()]
	deck.erase(c)
	print("Road: random card: ", c )
	return c

func restart_game():
	print("Road: restarting game")
	for c in cardsInPlay:
		c.queue_free()
	for c in hand:
		c.queue_free()
	for c in jackHand:
		c.queue_free()
	for c in road:
		c.queue_free()
	burn.queue_free()
	for c in discard:
		c.queue_free()
	reset_values()
	initialize()
	Global.world.get_tree().call_group("SweetHandJack", "reset_game")

func reset_values():
	bet = 1
	betButtonAmount = 1
	betRounds = 0
	burn
	cardsInPlay = []
	#chips = 100
	deck = range(0, 52)
	discard = []
	discardSelection
	hand = []
	jackHand = []
	jackRank = 0
	playerRank = 0
	road = []
	roadRemaining = 3
	wager = 0
	wagerDifference = 0

func show_jack_hand():
	show_jack_hand_helper(0)

func show_jack_hand_helper(c):
	if c is Dictionary:
		c = c["idx"]
	if c < jackHand.size():
		play_sound("res://Sounds/jrpgUI/Close.wav", 0, (-1 + c))
		print("showing ", c, ": ", jackHand[c])
		if jackHand[c].isFlipped:
			jackHand[c].flip()
		jackHand[c].set_deal_to(Vector2(512,200) + (Vector2(100,-60) * c), Vector2.ONE * 0.3, 0 + (100 * c))
		Global.world.queue_timer(self, 0.2, "show_jack_hand_helper", {"idx":c + 1})
	else:
		Global.world.queue_timer(self, 0.2, "alert_game_over")


func show_mouse():
	Utils.show_mouse()
	Input.set_custom_mouse_cursor(null)

func show_pointer(posx):
	Input.set_custom_mouse_cursor(emptyCursor)
	$Container/Pointer.visible = true
	$Container/Pointer.global_position.x = posx

func start_betting():
	show_mouse()
	update_ui_container(true)
	update_ui_skip_bet(true)
	update_ui_betting(true)
	pass

func start_discard(card):
	play_sound("res://Sounds/Audio/confirmation_001.ogg", -3)
	discardSelection = card
	$ButtonRoad.disabled = true
	$ButtonRoad.visible = false
	$BurnButton.disabled = true
	$BurnButton.visible = false
	for c in hand:
		c.isSelectable = false
	discardSelection.play_animation("hover")
	if discard.size() > 0:
		$DiscardButton.disabled = false
		$DiscardButton.visible = true
	burn.isSelectable = true
	burn.connect("emit_clicked", self, "exchange_burn_for_hand")

func start_reveal():
	Global.world.get_tree().call_group("SweetHandJack", "set_animation", "Reveal")

func start_turn():
	print("begin turn")
	play_sound("res://Sounds/jrpgUI/LoadSave.wav", -11)
	update_ui_container(true)
	$ButtonRoad.visible = true
	$ButtonRoad.disabled = false
	$BurnButton.disabled = false
	$BurnButton.visible = true
	for c in hand:
		print(c.cardID, ", ", c.value, ", ", c.get_suite_shorthand())
		c.isSelectable = true
		c.connect("emit_clicked", self, "start_discard")
	Utils.show_mouse()
	Input.set_custom_mouse_cursor(null)

func turn_one():
	play_sound("res://Sounds/Audio/confirmation_004.ogg", -18, 1 + (3 - roadRemaining) * 0.1)
	road[3 - roadRemaining].flip()
	roadRemaining -= 1


func update_bet(amount):
	bet = clamp(bet + amount,1,chips - wagerDifference)
	$Container/UIContainer/BetLabel.text = String(bet)
	$Container/UIContainer/BetUIContainer/Increase/IncreaseTimerTick.start(0.5 - (float(bet) / float(chips)))

func update_chips_ui():
	$Container/UIContainer/ChipsLabel.text = String(chips)

func update_ui_betting(s):
	$Container/UIContainer/BetUIContainer.visible = s
	$Container/UIContainer/BetLabel.visible = s

func update_ui_container(s):
	$Container/UIContainer.visible = s

func update_ui_raise_call(s):
	$Container/UIContainer/RaiseButton.visible = s
	$Container/UIContainer/RaiseButton.disabled = !s
	$Container/UIContainer/CallButton.visible = s
	$Container/UIContainer/CallButton.disabled = !s


func update_ui_skip_bet(s):
	$Container/UIContainer/SkipButton.visible = s
	$Container/UIContainer/SkipButton.disabled = !s
	$Container/UIContainer/BetButton.visible = s
	$Container/UIContainer/BetButton.disabled = !s

func update_wager_ui():
	$Container/UIContainer/WagerLabel.text = String(wager)

func _on_ButtonRoad_pressed():
	print("Road Button Pressed")
	turn_one()
	if roadRemaining <= 0:
		print("GAME OVER")
		#evaluate hand
		#evaluate_hands()
		#start_reveal()
		Global.world.queue_timer(self, 0.5, "alert_show_em")
		#alert_show_em()
	else:
		end_turn()


func _on_ButtonRoad_mouse_entered():
	if roadRemaining > 0:
		show_pointer(get_node("Container/TheRoad/" + String(7 - roadRemaining)).global_position.x)
		play_sound("res://Sounds/Audio/maximize_006.ogg", -18)
	pass # Replace with function body.


func _on_ButtonRoad_mouse_exited():
	hide_pointer()
	pass # Replace with function body.


func _on_BetButton_pressed():
	print("Road: BET ", bet)
	play_sound("res://Sounds/Audio/confirmation_003.ogg", -18)
	wagerDifference = bet
	wager += wagerDifference
	place_bet()
	jack_think()
	pass # Replace with function body.


func _on_Increase_button_down():
	play_sound("res://Sounds/Audio/select_003.ogg")
	betButtonAmount = 1
	update_bet(betButtonAmount)
	pass # Replace with function body.


func _on_IncreaseTimerTick_timeout():
	if $Container/UIContainer/BetUIContainer/Increase.pressed or $Container/UIContainer/BetUIContainer/Decrease.pressed:
		update_bet(betButtonAmount)
	pass # Replace with function body.


func _on_Decrease_button_down():
	play_sound("res://Sounds/Audio/select_004.ogg")
	betButtonAmount = -1
	update_bet(betButtonAmount)
	pass # Replace with function body.


func _on_BurnButton_mouse_entered():
	show_pointer($Container/Deck.global_position.x)
	play_sound("res://Sounds/Audio/drop_001.ogg", -10)
	pass # Replace with function body.

func _on_BurnButton_pressed():
	print("Road: Burn one")
	play_sound("res://Sounds/misc_01.wav", 0.0)
	burn.set_deal_to($Container/Discard.global_position, Vector2(0.3,0.3), 360)
	if discard.size() > 0:
		burn.z_index = discard.back().z_index + 1
	discard.append(burn)
	burn = create_card($Container/Deck.global_position, Vector2(0.3,0.3), 0)
	burn.global_position = $Container/Deck.global_position
	burn.flip()
	end_turn()
	pass # Replace with function body.


func _on_BurnButton_mouse_exited():
	hide_pointer()
	pass # Replace with function body.


func _on_DiscardButton_mouse_entered():
	play_sound("res://Sounds/Audio/drop_001.ogg")
	show_pointer($Container/Discard.global_position.x)
	pass # Replace with function body.


func _on_DiscardButton_mouse_exited():
	hide_pointer()
	pass # Replace with function body.


func _on_DiscardButton_pressed():
	print("Road: Player select discard")
	play_sound("res://Sounds/misc_02.wav")
	discardSelection.set_deal_to($Container/Discard.global_position, Vector2(0.3,0.3), 360)
	discardSelection.play_animation("default")
	discardSelection.isSelectable = false
	discardSelection.disconnect("emit_clicked", self, "start_discard")
	var h = discard.pop_back()
	discardSelection.z_index = h.z_index
	h.z_index = 0
	discard.append(discardSelection)
	hand.erase(discardSelection)
	hand.append(h)
	h.set_deal_to(discardSelection.global_position, Vector2(0.5,0.5),0)
	h.z_index = clamp(h.z_index - 1, 0, 999)
	end_turn()
	
	#pick up from deck
	pass # Replace with function body.


func _on_RaiseButton_pressed():
	print("Road: RAISE! ", wagerDifference, " + ", bet)
	play_sound("res://Sounds/Audio/maximize_008.ogg")
	var oldbet = wagerDifference
	wagerDifference += bet
	wager += wagerDifference
	place_bet()
	wagerDifference = bet
	jack_think()
	#jack_start_turn()
	pass # Replace with function body.


func _on_SkipButton_button_down():
	print("Player: check!")
	play_sound("res://Sounds/Audio/minimize_008.ogg")
	wagerDifference = 0
	end_betting()
	betRounds += 1
	if betRounds > 1:
		alert_player_turn()
		#start_turn()
	else:
		jack_think()
	pass # Replace with function body.


func _on_CallButton_button_down():
	print("Road: player CALL! ", wagerDifference)
	play_sound("res://Sounds/alert_06.wav")
	place_bet()
	wagerDifference = 0
	#jack_think()
	alert_player_turn()
	#start_turn()
	pass # Replace with function body.
