extends Spatial

signal pull(controller)
signal stop()

enum State {Pulling,Retracting,Idle}

var state = State.Idle

func _process(delta):
	match state:
		State.Pulling:
			pull_lever(delta)
		State.Retracting:
			pull_lever(delta, false)

func pull_lever(delta, forwards = true):
	if forwards:
		if($LeverArm.rotation_degrees.x < 50):
			$LeverArm.rotation_degrees.x += 25 * delta
	else:
		if($LeverArm.rotation_degrees.x > 0):
			$LeverArm.rotation_degrees.x -= 25 * delta
		else:
			state = State.Idle

func _on_Interactable_interaction(controller):
	print("released lever...")
	emit_signal("stop")
	state = State.Retracting
	pass # Replace with function body.


func _on_Interactable_holding(controller):
	print("pulling lever....")
	if state != State.Pulling:
		emit_signal("pull", controller)
	state = State.Pulling
	pass # Replace with function body.


func _on_Interactable_release():
	emit_signal("stop")
	state = State.Retracting
	pass # Replace with function body.
