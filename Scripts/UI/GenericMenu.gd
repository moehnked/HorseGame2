extends Control

var prevMenuRef

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	if not is_in_group("UI_Special"):
		add_to_group("UI_Special")

func _input(event):
	Global.InputObserver.check_input_source(event)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.InputObserver.isJoypadMode:
		Utils.capture_mouse()
	else:
		Utils.show_mouse(true)
	if Input.is_action_just_released("Start") or Input.is_action_just_released("ui_cancel"):
		deload()

func deload():
	prevMenuRef.exit_submenu()
	queue_free()

func initialize(prevMenu):
	prevMenuRef = prevMenu
