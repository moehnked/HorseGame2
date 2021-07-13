extends Node2D


var state = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	print("MOUSE WHEEL TUTORIAL START")
	$AnimationPlayer.play("MouseUp")
	Global.InputObserver.subscribe(self)
	pass # Replace with function body.


func parse_input(input):
	match state:
		0:
			if input.mouse_up:
				$Sprite2.visible = true
				$Sprite.visible = false
				state = 1
		2:
			$Sprite3/Clickable2.enabled = true
		3:
			if input.mouse_down:
				Global.InputObserver.unsubscribe(self)
				$UpdatePatchesOptions.trigger(self)
				queue_free()


func _on_Clickable_emit_click():
	print("clicked.... tutorial")
	if state == 1:
		$Sprite2.queue_free()
		$Sprite3.visible = true
		state = 2
	pass # Replace with function body.


func _on_Clickable2_trigger(trig):
	print("second clicke.... tutorial")
	if state == 2:
		$Sprite3.queue_free()
		$Sprite.visible = true
		$AnimationPlayer.playback_speed = -1
		state = 3
	pass # Replace with function body.
