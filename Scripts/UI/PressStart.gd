extends RichTextLabel

signal started()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_released("Start") or Input.is_action_just_released("ui_accept"):
		emit_signal("started")
#	pass
