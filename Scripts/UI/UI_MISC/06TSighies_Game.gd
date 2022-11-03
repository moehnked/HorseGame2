extends Node2D

export(Array, Resource) var sfx_lasers = []

var playerRef
var slotmachineRef
var hasPulled = false
var hasRolled = false
var wager = 0
var spritesRevealed = 0

signal emit_score(score)

func _ready():
	Utils.show_mouse(true)
	Global.InputObserver.canPause = false
	pass

func _process(delta):
	$ReadyToRoll.visible = not hasRolled and wager > 0
	if Input.is_action_just_released("ui_cancel") and not hasRolled:
		slotmachineRef.cancel()

func initialize(_playerRef, _slotref):
	playerRef = _playerRef
	slotmachineRef = _slotref
	#$ViewportContainer/display_container_chips/ChipsLabel.text = str(playerRef.chips)
	#$ViewportContainer/display_container_wager/WagerLabel.text = "0"


func _on_StopButton_pressed():
	if not hasPulled:
		hasPulled = true
		$AnimationPlayer.play("Pull")
		$SpriteRevealTimer.start()
		$sfx_rolling.stop()
		$sfx_stop.play()
		$sfx_pullarm.play()
	pass # Replace with function body.


func check_score():
	#check any horizontal matches
	var h = helper_check_horizontal()
	#check any vertical matches
	var v = helper_check_vertical()
	#check any diagonal matches
	var d = helper_check_diagonal()
	var smod = h + v + d
	var s = wager * smod
	print(s)
	emit_signal("emit_score", s if s >= wager else -1, wager)
	pass

func decrease_wager():
	wager = max(wager - 10, 0)
	update_chip_display()

func helper_check_diagonal():
	var s = $ResultsContainer.get_children()
	var row1 = s[0].get_score() if s[0].get_score() == s[4].get_score() and s[4].get_score() == s[8].get_score() else 0
	var row2 = s[6].get_score() if s[6].get_score() == s[4].get_score() and s[4].get_score() == s[3].get_score() else 0
	return row1 + row2

func helper_check_horizontal():
	var s = $ResultsContainer.get_children()
	var row1 = s[0].get_score() if s[0].get_score() == s[1].get_score() and s[1].get_score() == s[2].get_score() else 0
	var row2 = s[3].get_score() if s[3].get_score() == s[4].get_score() and s[4].get_score() == s[5].get_score() else 0
	var row3 = s[6].get_score() if s[6].get_score() == s[7].get_score() and s[7].get_score() == s[8].get_score() else 0
	return row1 + row2 + row3

func helper_check_vertical():
	var s = $ResultsContainer.get_children()
	var row1 = s[0].get_score() if s[0].get_score() == s[3].get_score() and s[3].get_score() == s[6].get_score() else 0
	var row2 = s[1].get_score() if s[1].get_score() == s[4].get_score() and s[4].get_score() == s[7].get_score() else 0
	var row3 = s[2].get_score() if s[2].get_score() == s[5].get_score() and s[5].get_score() == s[8].get_score() else 0
	return row1 + row2 + row3

func increase_wager():
	if playerRef.chips >= wager + 10:
		wager += 10
	update_chip_display()

func update_chip_display():
	$BetContainer/betAmount.text = ("0" if wager < 10 else "") + str(wager)


func _on_increaseWager_pressed():
	increase_wager()
	pass # Replace with function body.

func _on_ReadyToRoll_pressed():
	if not hasRolled:
		$AnimationPlayer.play("startRoll")
		$ReadyToRoll.visible = false
		hasRolled = true
		$sfx_rolling.play()
		$PullStopContainer.visible = true
		$WaagerButtonContainer.visible = false
	pass # Replace with function body.


func _on_SpriteRevealTimer_timeout():
	if spritesRevealed < 9:
		var s = $ResultsContainer.get_children()
		s[spritesRevealed].visible = true
		s[spritesRevealed].randomize_sprite()
		spritesRevealed += 1
		$SpriteRevealTimer.start()
		Global.AudioManager.play_sound(Utils.get_random(sfx_lasers))
	else:
		check_score()
	pass # Replace with function body.
