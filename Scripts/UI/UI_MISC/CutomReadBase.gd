extends Control

var bgAlpha = 0.0
var bgAlphaLim = 0.5
var canExit = false

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	get_tree().paused = true
	Global.world.get_tree().call_group("3DViewport", "set_material", 'normalDither')

func _process(delta):
	Global.world.get_tree().call_group("3DViewport", "increment_fade")
	
	if bgAlpha < bgAlphaLim:
		bgAlpha = lerp(bgAlpha, bgAlphaLim, 0.025)
		$BG.modulate.a = bgAlpha
	if Input.is_action_just_released("ui_cancel") or Input.is_action_just_released("ui_accept") or Input.is_action_just_pressed("engage"):
		if canExit:
			queue_free()
		else:
			$AnimationPlayer.seek(0.9, true)
			canExit = true

func queue_free():
	get_tree().paused = false
	Global.world.get_tree().call_group("3DViewport", "clear")
	.queue_free()

func set_can_exit(val = true):
	canExit = val
