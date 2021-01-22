extends Spatial

func _ready():
	$RM_White_Horse_Rig/Skeleton/RM_White_Horse

func play_animation(anim):
	$AnimationPlayer2.play(anim)

func set_playback_speed(spd = 1.0):
	$AnimationPlayer2.playback_speed = spd
