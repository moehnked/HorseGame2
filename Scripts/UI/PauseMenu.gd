extends Control

var canExit = false

var sfx = {
	"open":preload("res://Sounds/UI_Open_02.wav"),
	"close":preload("res://Sounds/UI_Close_02.wav")
}
var settingsRef = preload("res://prefabs/UI/SettingsMenu.tscn")
var dataRef = preload("res://prefabs/UI/DataMenu.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	get_tree().paused = true
	Global.AudioManager.play_sound(sfx["open"])
	if not Global.InputObserver.isJoypadMode:
		Utils.show_mouse(true)
	$OptionsContainer/Data.grab_focus()
	pass # Replace with function body.

func deload():
	Global.AudioManager.play_sound(sfx["close"])
	get_tree().paused = false
	Utils.capture_mouse()
	queue_free()

func enter_submenu():
	visible = false
	pause_mode = Node.PAUSE_MODE_STOP
	for c in $OptionsContainer.get_children():
		c.focus_mode = FOCUS_NONE

func enter_data_menu():
	enter_submenu()
	Global.world.instantiate(dataRef.instance()).initialize(self)

func enter_settings():
	enter_submenu()
	Global.world.instantiate(settingsRef.instance()).initialize(self)

func exit_game():
	get_tree().quit()

func exit_submenu():
	visible = true
	$AnimationPlayer.play("startup")
	pause_mode = Node.PAUSE_MODE_PROCESS
	for c in $OptionsContainer.get_children():
		c.focus_mode = FOCUS_ALL
	$OptionsContainer/Data.grab_focus()

func queue_save_world():
	$Delay.trigger()

func save_world():
	Global.world.save_world()

func _input(event):
	Global.InputObserver.check_input_source(event)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.InputObserver.isJoypadMode:
		Utils.capture_mouse()
	else:
		Utils.show_mouse(true)
		
	if (Input.is_action_just_released("Start") or Input.is_action_just_released("ui_cancel")) and canExit:
		deload()
	canExit = true
	if Input.is_action_just_pressed("ui_focus_next") or Input.is_action_just_pressed("ui_focus_prev"):
		if get_focus_owner() == null:
			$OptionsContainer/Data.grab_focus()
#	pass

