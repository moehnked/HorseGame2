extends Control

export var viewportEffects = true
export var eventGroupAfterRead = ""

var bgAlpha = 0.0
var bgAlphaLim = 0.5
var canExit = false

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	get_tree().paused = true
	#Global.world.get_tree().call_group("3DViewport", "set_material", 'normalDither')
	if viewportEffects:
		get_tree().call_group("3DViewport", "set_material", 'normalDither')

func _process(delta):
	Global.world.get_tree().call_group("3DViewport", "increment_fade")
	
	if bgAlpha < bgAlphaLim:
		bgAlpha = lerp(bgAlpha, bgAlphaLim, 0.025)
		$BG.modulate.a = bgAlpha
	if Input.is_action_just_released("ui_cancel") or Input.is_action_just_released("ui_accept") or Input.is_action_just_pressed("engage"):
		if canExit:
			$AnimationPlayer.play("reverse")
			Global.AudioManager.play_sound("res://Sounds/UI_Close_03.wav")
		else:
			$AnimationPlayer.seek(0.9, true)
			canExit = true

func queue_free():
	get_tree().paused = false
	Global.world.get_tree().call_group("3DViewport", "clear")
	if eventGroupAfterRead != "":
		get_tree().call_group(eventGroupAfterRead, "trigger", self)
	.queue_free()

func set_can_exit(val = true):
	canExit = val
