extends Node2D


export(float, -100, 100) var animSpeed = 1.0
var targetAlpha = 0.0
var minute = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("New Anim")
	$AnimationPlayer.playback_speed = 0.01
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#$origin.rotation_degrees = lerp($origin.rotation_degrees, $origin.rotation_degrees + thresh, weight)
	minute = Global.Sun.get_minute()
	targetAlpha = 1.0 if (minute > 900 or minute < 300) else 0.0
	modulate.a = lerp(modulate.a, targetAlpha, 0.01)
	pass
