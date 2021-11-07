extends Spatial

var RPSThrown = 0

func _ready():
	#$RM_White_Horse_Rig/Skeleton/RM_White_Horse
	pass

func play_animation(anim):
	$AnimationPlayer2.play(anim)

func set_playback_speed(spd = 1.0):
	$AnimationPlayer2.playback_speed = spd

func higlight(toggle):
	var outline = $RM_White_Horse_Rig/Skeleton/RM_White_Horse.get_surface_material(0)
	outline.next_pass = load("res://Materials/outline_material_Green.tres") if toggle else load("res://Materials/outline_material.tres")

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

func _on_Horse_emit_highlight(toggle):
	#$horse_animate/RM_White_Horse_Rig/Skeleton/RM_White_Horse.set_surface_material(0, load("res://Materials/horse_material_light_brown_highlighted.tres"))
	#print("highlighting.... ", $RM_White_Horse_Rig/Skeleton/RM_White_Horse.get_surface_material_count())
	higlight(toggle)
	pass # Replace with function body.


func _on_Horse_NPC_emit_highlight(toggle):
	higlight(toggle)
	pass # Replace with function body.
