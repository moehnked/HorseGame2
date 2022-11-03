extends Spatial
var isAnimationPlaying:bool = true
var RPSSprite = "Rock"
var rpsGameRef
export(Dictionary) var handSprites

signal emit_animation_finished()

func apply_texture(tex):
	$Node2D/Sleeve/Arm.texture = handSprites[tex]
	pass
	
func conclude_rps():
	rpsGameRef.conclude()

func idle_hand():
	print("returning hand to idle")
	#$AnimationPlayer.play("Idle")
	#apply_texture(handMesh, "Idle")
	update_hand_sprite("Idle")
	reset_palm()

func on_animation_finished():
	emit_signal("emit_animation_finished")

func parse_rps():
	match RPSSprite:
		"Rock":
			update_sprite("Punch")
		"Paper":
			apply_texture("Idle")
		"Scissors":
			update_sprite("RPS")

func play_animation(anim, caller = null):
	$AnimationPlayer.play(anim)
	if caller != null:
		connect("emit_animation_finished", caller, "animation_return")

func reset_palm():
	get_parent().get_node("Palm").transform.origin = Vector3(0.8, -0.45, -2.247)

func set_animation_playback(b, seek = -1):
	isAnimationPlaying = b
	$AnimationPlayer.playback_speed = 1.0 if isAnimationPlaying else 0.0
	if seek > 0:
		$AnimationPlayer.seek(seek, true)

func set_rps(val, rpsCallback):
	rpsGameRef = rpsCallback
	match val:
		0:
			RPSSprite = "Paper"
		1:
			RPSSprite = "Scissors"
		2:
			RPSSprite = "Rock"


func toggle_animation_playback():
	set_animation_playback(!isAnimationPlaying)

func toggle_sprite_visibility():
	visible = !visible

func update_hand_sprite(spell, b = true, seek = -1):
	apply_texture(spell)
	set_animation_playback(b, seek)
	$AnimationPlayer.play(spell)

func update_sprite(spell):
	apply_texture(spell)

func _ready():
	$AnimationPlayer.play("Idle")
	
