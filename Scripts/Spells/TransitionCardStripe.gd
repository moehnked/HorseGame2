extends Node2D


var loops = 0
export(float) var pbSpeed = 0
export(float) var weight = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("SlideIn")
	$AnimationPlayer.playback_speed = 0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$AnimationPlayer.playback_speed = lerp($AnimationPlayer.playback_speed, pbSpeed, weight)
#	pass

func set_pb_speed(s):
	pbSpeed = s

func set_weight(w):
	weight = w

func _on_AnimationPlayer_animation_finished(anim_name):
	print(anim_name)
	loops += 1
	match loops:
		1:
			$AnimationPlayer.play("Sliding")
		2:
			$AnimationPlayer.play("SlideOut")
		3:
			queue_free()
	pass # Replace with function body.
