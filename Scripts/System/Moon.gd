extends Node2D


export(float, -100, 100) var animSpeed = 1.0
var hour = 0
var minute = 0
var targetAlpha = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("New Anim")
	$AnimationPlayer.playback_speed = 0.01
	pass # Replace with function body.

func hour_alert(h):
	hour = h

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	targetAlpha = 1.0 if (hour > 16 or hour < 3) else 0.0
	modulate.a = lerp(modulate.a, targetAlpha, 0.01)
	pass
