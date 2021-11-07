extends Node2D

signal animation_finished()
export(float, 0.0, 4.0) var aspeed = 0.5

func _ready():
	$AnimationPlayer.play("Sliding", -1, aspeed)

func set_anim_speed(val):
	aspeed = val
	$AnimationPlayer.playback_speed = aspeed

func anim_tick():
	emit_signal("animation_finished")

func _on_AnimationPlayer_animation_finished(anim_name):
	emit_signal("animation_finished")
	pass # Replace with function body.
