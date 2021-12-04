extends Spatial
var handMesh
var isAnimationPlaying:bool = true
var RPSSprite = "Rock"
var rpsGameRef
export(Dictionary) var handSprites

func apply_texture(mesh_instance_node, tex):
	mesh_instance_node.get_surface_material(0).albedo_texture = handSprites[tex]

func conclude_rps():
	rpsGameRef.conclude()

func idle_hand():
	print("returning hand to idle")
	$AnimationPlayer.play("Idle")
	apply_texture(handMesh, "Idle")

func parse_rps():
	match RPSSprite:
		"Rock":
			update_sprite("Punch")
		"Paper":
			apply_texture(handMesh, "Idle")
		"Scissors":
			update_sprite("RPS")

func play_animation(anim):
	$AnimationPlayer.play(anim)

func set_animation_playback(b):
	isAnimationPlaying = b
	$AnimationPlayer.playback_speed = 1.0 if isAnimationPlaying else 0.0

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

func update_hand_sprite(spell, b = true):
	apply_texture(handMesh, spell)
	set_animation_playback(b)
	$AnimationPlayer.play(spell)

func update_sprite(spell):
	apply_texture(handMesh, spell)

func _ready():
	$AnimationPlayer.play("Idle")
	handMesh = $Container/MeshInstance
