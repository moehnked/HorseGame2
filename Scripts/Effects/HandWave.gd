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
	Global.AudioManager.play_sound()
	$TriggerEventByGroup.trigger(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if hasSnapped:
		hasSnapped = false
		trigger()

func set_event_group(groupname):
	$TriggerEventByGroup.groupName = groupname
	pass

func _on_AnimationPlayer_animation_finished(anim_name):
	#queue_free()
	pass # Replace with function body.
