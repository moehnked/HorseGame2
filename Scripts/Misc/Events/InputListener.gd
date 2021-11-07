extends Node

export(String) var inputs = "ui_focus_next"

signal emit_trigger(trig)

func _process(delta):
	if Input.is_action_just_released(inputs):
		print("emit input listener event ", inputs)
		emit_signal("emit_trigger", self)
