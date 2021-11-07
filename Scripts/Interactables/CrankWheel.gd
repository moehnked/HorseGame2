extends "res://Scripts/Interactables/PuzzleTriggerer.gd"

var isTurning = false
var queueSound = false
var turn_ammount = 0

var controller

func parse_input(input):
	if input.engage:
		release()
	else:
		turn_ammount += input.right - input.left
		rotation_degrees.y = lerp(rotation_degrees.y, turn_ammount, 0.1)
		var x = int(turn_ammount)
		if  x % 25 == 0 and queueSound:
			Global.AudioManager.play_sound("res://Sounds/valve_" + String(Global.world.rng.randi_range(0,4)) + ".wav")
			queueSound = false
		elif x % 3 == 0:
			queueSound = true
		if turn_ammount >= 90:
			activate()
			release(true)

func _on_Interactable_holding(controller):
	if not isTurning:
		#this is the click
		$Interactable.set_interactable(false, true)
		Global.InputObserver.subscribe(self)
		Global.Player.unsubscribe_to()
		pass
	isTurning = true
	pass # Replace with function body.

func release(disableReset = false):
	print("crankwheel: released holding")
	Global.InputObserver.unsubscribe(self)
	Global.Player.subscribe_to()
	if not disableReset:
		$Timer.start()

func _on_Interactable_emit_prompt(_prompt):
	_prompt.prompt = "Turn "
	pass # Replace with function body.

func _on_Timer_timeout():
	print("crankwheeel: cooldown")
	$Interactable.set_interactable(true, true)
	pass # Replace with function body.
