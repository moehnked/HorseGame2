extends Spatial

var playerRef
var slotmachineRef
var stopped = 3
var hasPulled = false
var wager = 0

signal emit_score(score)

func _ready():
	#start_slots()
	Global.InputObserver.canPause = false
	pass # Replace with function body.

func _process(delta):
	if not hasPulled:
		if Input.is_action_just_released("ui_cancel"):
			slotmachineRef.cancel()
			$AnimationPlayer.play("fadeout")
		if Input.is_action_just_pressed("move_forward"):
			increase_wager()
		elif Input.is_action_just_pressed("move_backward"):
			decrease_wager()
		
		$ViewportContainer/label_container_pull.visible = wager > 0
		
		if Input.is_action_just_released("ui_accept"):
			hasPulled = true
			start_slots()
	elif Input.is_action_just_released("ui_accept") and stopped < 3:
		stop_one()
	
	if stopped < 3:
		$ViewportContainer/Viewport/SlotBar1.rotate_z(-.2)
	if stopped < 2:
		$ViewportContainer/Viewport/SlotBar2.rotate_z(-.2)
	if stopped < 1:
		$ViewportContainer/Viewport/SlotBar3.rotate_z(-.2)

func check_score():
	if $ViewportContainer/Sprite1.frame == $ViewportContainer/Sprite2.frame:
		if $ViewportContainer/Sprite1.frame == $ViewportContainer/Sprite3.frame:
			emit_signal("emit_score", $ViewportContainer/Sprite1.frame, wager)
			return
	emit_signal("emit_score", -1, wager)

func decrease_wager():
	wager = max(wager - 1, 0)
	update_chip_display()

func increase_wager():
	if playerRef.chips > 0:
		wager = min(wager + 1, playerRef.chips)
	update_chip_display()

func initialize(_playerRef, _slotref):
	playerRef = _playerRef
	slotmachineRef = _slotref
	$ViewportContainer/display_container_chips/ChipsLabel.text = str(playerRef.chips)
	$ViewportContainer/display_container_wager/WagerLabel.text = "0"

func start_slots():
	slotmachineRef.pull()
	$ViewportContainer/label_container_pull.visible = false
	$ViewportContainer/Sprite1.playing = true
	$ViewportContainer/Sprite2.playing = true
	$ViewportContainer/Sprite3.playing = true
	stopped = 0

func stop_one():
	stopped += 1
	var spr = get_node("ViewportContainer/Sprite" + str(stopped))
	spr.playing = false
	spr.frame = Utils.get_rng().randi_range(0,4)
	$AudioStreamPlayer.play()
	if stopped >= 3:
		print("game over")
		check_score()
		#$TTL.start()
		$AnimationPlayer.play("fadeout")
		#queue_free()
	pass

func update_chip_display():
	$ViewportContainer/display_container_wager/WagerLabel.text = str(wager)
	$ViewportContainer/display_container_chips/ChipsLabel.text = str(playerRef.chips - wager)


func queue_free():
	Global.InputObserver.canPause = true
	.queue_free()

func _on_TTL_timeout():
	queue_free()
	pass # Replace with function body.
