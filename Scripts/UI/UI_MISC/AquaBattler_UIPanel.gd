extends Node2D

signal emit_action_selection(action, _timerTarget, _timer)

var selectedIDX = 0
var timer
var timerTarget

func _process(delta):
	if $Pointer.visible:
		update_selected()
		if Input.is_action_just_pressed("move_backward"):
			clear_selected()
			selectedIDX = (selectedIDX + 1) % 4
		if Input.is_action_just_pressed("move_forward"):
			clear_selected()
			selectedIDX = (selectedIDX - 1) % 4
		if Input.is_action_just_released("ui_accept") or Input.is_action_just_released("standard"):
			$AnimationPlayer.call_deferred("play", "Hide")
			timer.visible = false
			$Pointer.visible = false

func clear_selected():
	var c = $Panel/Control/VBoxContainer.get_children()
	c[selectedIDX].modulate = Color(1,1,1,0.45)

func open_ui_panel(_timer, _timerTarget):
	timer = _timer
	timerTarget = _timerTarget
	$AnimationPlayer.play("Reveal")
	pass # Replace with function body.

func update_selected():
	var c = $Panel/Control/VBoxContainer.get_children()
	c[selectedIDX].modulate = Color(1,1,1,1)
	$Pointer.position.y = $Panel/Control.rect_position.y + c[selectedIDX].rect_position.y

func parse_mouse_select(idx):
	if $Pointer.visible:
		clear_selected()
		selectedIDX = idx
		update_selected()

func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"Hide":
			emit_signal("emit_action_selection", selectedIDX, timerTarget, timer)
	pass # Replace with function body.
