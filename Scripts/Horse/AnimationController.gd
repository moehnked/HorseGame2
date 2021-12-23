extends Spatial

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
	match $AnimationPlayer2.current_animation:
		"Trot":
			print("trot: ", get_frame())
			if Utils.compare_floats(get_frame(), 0.8, 0.01):
				play_sound()
			pass 

func get_frame():
	return $AnimationPlayer2.current_animation_position
	
func get_model():
	return $RM_White_Horse_Rig/Skeleton/RM_White_Horse

func play_animation(anim):
	$AnimationPlayer2.play(anim)

func set_playback_speed(spd = 1.0):
	$AnimationPlayer2.playback_speed = spd

func highlight(toggle):
	var outline = $RM_White_Horse_Rig/Skeleton/RM_White_Horse.get_surface_material(0)
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
