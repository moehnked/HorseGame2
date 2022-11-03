extends Spatial

export(NodePath) var animationPlayer
export(NodePath) var hitbox
export(NodePath) var model
export(NodePath) var rig
export(bool) var soundWhileMoving = true

var attackAnimationFinished = true
var RPSThrown = 0
var sfx = [
	"res://Sounds/gallop1.wav",
	"res://Sounds/gallop2.wav",
	"res://Sounds/gallop3.wav",
	"res://Sounds/gallop4.wav",
	"res://Sounds/gallop5.wav",
]

func _ready():
	#$RM_White_Horse_Rig/Skeleton/RM_White_Horse
	pass

func _process(delta):
	match get_animation_player().current_animation:
		"Trot":
			if soundWhileMoving:
				if Utils.compare_floats(get_frame(), 0.8, 0.01):
					play_sound()
			pass 

func add_hat(item):
	get_hat_point().add_child(item)
	item.global_transform = Transform(get_hat_point().global_transform)

func finish_attack_anim():
	attackAnimationFinished = true

func get_animation_player():
	return get_node(animationPlayer)

func get_frame():
	return get_animation_player().current_animation_position

func get_hat_point():
	return get_rig().get_node("Skeleton/BoneAttachment/HatPoint")

func get_hitbox():
	return get_node(hitbox)

func get_model():
	#return $RM_White_Horse_Rig/Skeleton/RM_White_Horse
	return get_node(model)

func get_rig():
	return get_node(rig)

func init_hitbox(hbox):
	hbox.initialize({"actor": get_parent(), "dmg": get_parent().stats["girth"]})

func play_animation(anim):
	get_animation_player().play(anim)
	get_hitbox().set_active(false)

func set_playback_speed(spd = 1.0):
	get_animation_player().playback_speed = spd

func highlight(toggle):
	var outline = get_model().get_surface_material(0)
	outline.next_pass = load("res://Materials/outline_material_Green.tres") if toggle else load("res://Materials/outline_material.tres")

func set_material(mat):
	get_model().set_surface_material(0, mat)

func shoot_rps():
	RPSThrown = Global.world.rng.randi() % 3
	print("HORSE rps SELECTED ", RPSThrown)
	match RPSThrown:
		0:
			play_animation("RPS_Shoes")
		1:
			play_animation("RPS_Fets")
		2:
			play_animation("RPS_Hooves")

func play_attack_anim(idx):
	attackAnimationFinished = false
	match idx:
		0:
			play_animation("Attack")
		1:
			play_animation("Attack_0")
		2:
			play_animation("Attack_1")

func play_random_attack():
	play_attack_anim(Utils.get_rng().randi_range(0,2))

func play_sound():
	if owner.get_state() == "Pilot":
		Global.AudioManager.play_sound(Utils.get_random(sfx))
	else:
		Global.AudioManager.play_sound_3d(Utils.get_random(sfx), 5, global_transform.origin, 3)

func _on_Horse_emit_highlight(toggle):
	#$horse_animate/RM_White_Horse_Rig/Skeleton/RM_White_Horse.set_surface_material(0, load("res://Materials/horse_material_light_brown_highlighted.tres"))
	#print("highlighting.... ", $RM_White_Horse_Rig/Skeleton/RM_White_Horse.get_surface_material_count())
	highlight(toggle)
	pass # Replace with function body.

func _on_Horse_NPC_emit_highlight(toggle):
	highlight(toggle)
	pass # Replace with function body.
