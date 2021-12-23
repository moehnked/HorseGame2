extends Control

var prevMenuRef

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	$VolumeSlider.value = Global.AudioManager.sfxVolume
	$MusicSlider.value = Global.AudioManager.musicVolume
	$FullscreenToggle.pressed = OS.window_fullscreen
	update_music_volume($MusicSlider.value)
	update_sfx_volume($VolumeSlider.value)

func _process(delta):
	if Input.is_action_just_released("Start") or Input.is_action_just_released("ui_cancel"):
		deload()

func deload():
	prevMenuRef.exit_submenu()
	queue_free()

func initialize(prevMenu):
	prevMenuRef = prevMenu

func update_sfx_volume(value):
	Global.AudioManager.set_sfx_volume(value)
	$VolumeSlider/Label.text = String(floor(value * 100)) + "%"
	pass # Replace with function body.

func update_music_volume(value):
	Global.AudioManager.set_music_volume(value)
	$MusicSlider/Label.text = String(floor(value * 100)) + "%"
	pass # Replace with function body.


func _on_CheckButton_pressed():
	OS.window_fullscreen = $FullscreenToggle.pressed
	pass # Replace with function body.
