extends "res://Scripts/Interactables/PuzzleTriggerer.gd"

var isTurning = false
var queueSound = false
var turn_ammount = 0

var controller

func parse_input(input):
	turn_ammount += max(input.right - input.left, -input.mouse_horizontal) * 2
	rotation_degrees.y = lerp(rotation_degrees.y, turn_ammount, 0.1)
	var x = int(turn_ammount)
	if  x % 25 == 1 and queueSound:
		Global.AudioManager.play_sound("res://Sounds/valve_" + String(Global.world.rng.randi_range(0,4)) + ".wav")
		queueSound = false
	elif x % 3 == 0:
		queueSound = true
	if turn_ammount >= 90:
		activate()
		release()
		$Interactable.queue_free()

func release():
	isTurning = false
	Global.InputObserver.unsubscribe(self)
	Global.Player.subscribe_to()

func _on_Interactable_emit_prompt(_prompt):
	_prompt.prompt = "Turn - Hold:"
	pass # Replace with function body.


func _on_Interactable_holding(controller):
	print("Crankwheel: turning")
	if not isTurning:
		Global.InputObserver.subscribe(self)
		Global.Player.unsubscribe_to()
	isTurning = true
	pass # Replace with function body.


func _on_Interactable_release():
	print("releasing crankwheel")
	isTurning = false
	Global.InputObserver.unsubscribe(self)
	Global.Player.subscribe_to()
	pass # Replace with function body.
