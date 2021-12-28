extends Node2D


var state = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	print("MOUSE WHEEL TUTORIAL START")
	$AnimationPlayer.play("MouseUp")
	Global.InputObserver.subscribe(self)
	initialize()
	pass # Replace with function body.


func initialize():
	state = 0
	$Sprite2.visible = false
	$Sprite3.visible = false
	$Sprite.visible = true
	$AnimationPlayer.play("MouseUp")

func flip_d_pad():
	get_node("Sprite3/d_pad_1/d-pad_3_button").flip_v = !get_node("Sprite3/d_pad_1/d-pad_3_button").flip_v

func parse_input(input):
	match state:
		0:
			if input.mouse_up:
				$Sprite2.visible = true
				$Sprite.visible = false
				state = 1
		1, 2:
			if input.mouse_down:
				initialize()
		3:
			if input.mouse_down:
				Global.InputObserver.unsubscribe(self)
				$TriggerEventByGroup.trigger(self)
				queue_free()



func _on_GenericUiEvent_trigger(trig):
	print("tutorial: clicked ", trig, ", ", trig.name)
	if state == 1:
		$Sprite2.visible = false
		$Sprite3.visible = true
		state = 2
	pass # Replace with function body.


func _on_HandOptionSelected_trigger(trig):
	print("selected PUNCJHHHHH!")
	initialize()
	state = 3
	$AnimationPlayer.playback_speed = -1
	get_node("Sprite/d_pad_2/d-pad_3").flip_v = true
	get_node("Sprite/d_pad_2/Label").visible = false
	pass # Replace with function body.
