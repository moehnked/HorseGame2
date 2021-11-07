extends Spatial
var handMesh
var isAnimationPlaying:bool = true
var RPSSprite = "Rock"
var rpsGameRef

func apply_texture(mesh_instance_node, texture_path):
	var texture = ImageTexture.new()
	var image = Image.new()
	image.load(texture_path)
	texture.create_from_image(image)
	mesh_instance_node.get_surface_material(0).albedo_texture = texture

func conclude_rps():
	rpsGameRef.conclude()

func idle_hand():
	print("returning hand to idle")
	$AnimationPlayer.play("Idle")
	apply_texture(handMesh, "res://Sprites/Player/Hand_idle.png")

func parse_rps():
	match RPSSprite:
		"Rock":
			update_sprite("Punch")
		"Paper":
			apply_texture(handMesh, "res://Sprites/Player/Hand_idle.png")
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
	#print("applying")
	apply_texture(handMesh, "res://Sprites/Player/Hand_" + spell + ".png")
	set_animation_playback(b)
	$AnimationPlayer.play(spell)

func update_sprite(spell):
	#print("applying")
	apply_texture(handMesh, "res://Sprites/Player/Hand_" + spell + ".png")
	#set_animation_playback(b)
	#$AnimationPlayer.play(spell)

func _ready():
	$AnimationPlayer.play("Idle")
	handMesh = $Container/MeshInstance
