extends Spatial

func play():
	print("gear: starting playback")
	$AnimationPlayer.play("Spin")
	$AnimationPlayer.playback_speed = 1.0
	
func stop():
	$AnimationPlayer.playback_speed = 0.0
