extends Node2D

signal emit_timer_ready()
signal emit_select(timer, target)

export(NodePath) var target

var state = State.waiting
var weight = 0.1
var isSelected = false

enum State {waiting, ready, turnend}

func _process(delta):
	match state:
		State.waiting:
			timer_tick()
		State.ready:
			if (Input.is_action_just_released("standard") or Input.is_action_just_released("ui_accept")) and isSelected:
				emit_signal("emit_select", self, get_node(target))
				clear_timer(false)

func clear_timer(reset_light = true, hide = false):
	$RichTextLabel.visible = false
	isSelected = false
	$Pointer.visible = false
	$Light2D.scale.x = 4.1 if reset_light else $Light2D.scale.x
	visible = not hide

func ready_timer():
	state = State.ready
	$RichTextLabel.visible = true
	set_focus(false)
	emit_signal("emit_timer_ready")
	pass

func set_focus(val = true):
	isSelected = val
	$Pointer.visible = isSelected

func start_timer():
	visible = true
	$Light2D.visible = true
	$Light2D.scale.x = 4.1
	state = State.waiting
	$RichTextLabel.visible = false

func timer_tick():
	$Light2D.scale.x -= weight
	if $Light2D.scale.x <= 0:
		ready_timer()
	pass
