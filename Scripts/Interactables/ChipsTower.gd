extends Spatial

enum State{Idle,Shoot,Payout}

export var gameSpeed = 0.02

var barIdx = 0
var playcost = 7
var isJackpot = false
var jackpot = 50
var payout = 0
var playerRef
var state = State.Idle
var scoreOrder = [2,3,4,5,4,3,2,1,2,3,4,5,6,7,8,9,1,9,8,7,6,6,10,-1,10,6,7,8,1,9,8,7,6,5,4,3,2,1,2,3,4,5,4,3,2]
var target_jackpot = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	for c in $LedBG.get_children():
		c.visible = false
	update_jackpot_display()
	pass # Replace with function body.

func blink_random_light():
	var lights = $LedBG.get_children()
	var current = lights[barIdx]
	current.visible = false
	var n = Utils.get_random(lights)
	n.visible = true
	barIdx = lights.find(n)

func check_valid_game(controller):
	var p = controller.get_parent()
	if p != null:
		if "chips" in p:
			if p.chips >= playcost:
				playerRef = p
				p.chips -= playcost
				start_game()

func payout():
	payout = scoreOrder[barIdx]
	isJackpot = (payout < 0)
	playerRef.chips += jackpot if isJackpot else payout
	target_jackpot = 10 if isJackpot else jackpot + payout

func reset_game():
	for c in $LedBG.get_children():
		c.visible = false
	$music.stop()
	payout = 0
	isJackpot = false
	blink_random_light()
	state = State.Idle
	$ledBlink.stop()
	$Interactable.set_interactable(true, true, false)
	$idleBlink.start()

func start_game():
	$idleBlink.stop()
	$LedBG.get_children()[barIdx].visible = false
	barIdx = 0
	$ledTime.start(gameSpeed)
	$sfx_loop.play()
	state = State.Shoot

func stop_bar():
	$ledTime.stop()
	$sfx_loop.stop()
	$ledBlink.start()
	$endgameTimer.start()
	state = State.Payout
	$Interactable.set_interactable(false, true, true)
	payout()
	$endgameTimer.start()
	$music.play()
	#play endgamesong
	#if we did not get a jackpot, the jackpot needs to increase by how much we scored
	#if we did get a jackpot then it needs to reset to 10
	##play jackpot song

func update_jackpot_display():
	var txt = ""
	if jackpot < 100:
		txt += "0"
	if jackpot < 10:
		txt += "0"
	$ViewportContainer/Viewport/JackpotLabel.text = txt + str(jackpot)
	$sfx_displaytick.play()

func _on_Interactable_emit_prompt(_prompt):
	match state:
		State.Idle:
			_prompt.prompt = "Play ("+ str(playcost)+ "chips)"
		State.Shoot:
			_prompt.prompt = "Stop"
		State.Payout:
			_prompt.prompt = ""
	pass # Replace with function body.


func _on_Interactable_interaction(controller):
	match state:
		State.Idle:
			check_valid_game(controller)
		State.Shoot:
			stop_bar()
	pass # Replace with function body.


func _on_ledTime_timeout():
	var leds = $LedBG.get_children()
	leds[barIdx].visible = false
	barIdx = (barIdx + 1) % leds.size()
	leds[barIdx].visible = true
	pass # Replace with function body.


func _on_ledBlink_timeout():
	var stopped = $LedBG.get_children()[barIdx]
	stopped.visible = !stopped.visible
	pass # Replace with function body.


func _on_endgameTimer_timeout():
	if target_jackpot > jackpot:
		jackpot += 1
		update_jackpot_display()
	elif target_jackpot < jackpot:
		jackpot -= 1
		update_jackpot_display()
	else:
		$endgameTimer.stop()
		$gameTTL.start()
		#reset_game()
	pass # Replace with function body.


func _on_gameTTL_timeout():
	reset_game()
	pass # Replace with function body.


func _on_idleBlink_timeout():
	blink_random_light()
	pass # Replace with function body.
