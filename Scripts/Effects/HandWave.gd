extends Control

export var playbackSpeedMod = 1.0
export var hasSnapped = false


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("New Anim")
	$AnimationPlayer.playback_speed = playbackSpeedMod
	pass # Replace with function body.

func trigger():
	print("SNAP!")
	$TriggerEventByGroup.trigger(self)


func set_event_group(groupname):
	$TriggerEventByGroup.groupName = groupname
	pass

func _on_AnimationPlayer_animation_finished(anim_name):
	#queue_free()
	pass # Replace with function body.
