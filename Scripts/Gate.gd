extends Area
var interactionPrompt = ""
var isOpen = false
var is_interactable = true


func interact(controller):
	isOpen = not isOpen
	$Open.visible = isOpen
	$Closed.visible = not isOpen
	$Blocker/CollisionShape2.disabled = isOpen
	interactionPrompt = prompt()
	controller.read_prompt()
	play_sound()
	pass
	
func play_sound():
	$AudioStreamPlayer.stop()
	$AudioStreamPlayer.stream = load("res://sounds/door_open.wav") if isOpen else load("res://sounds/door_close.wav")
	$AudioStreamPlayer.play()
	
func prompt():
	return "close" if isOpen else "open"
