extends Spatial

export(int) var dialoguePoint = 1
#export(Resource) dsRef
export(bool) var removeGroupOnReady = false
export(float, -50.0, 20.0) var speakingVolume = 1.0
export(Array, AudioStream) var sfx = []

#var dsRef = preload("res://prefabs/UI/Dialogue/Dialogic_NPC_DialogueScreen.tscn")

var headPointOrigin = Vector3()
var isLookingAtPlayer = false
var lookDistance = 2.0


func _ready():
	headPointOrigin = $Patches2/Armature/Skeleton/HeadPoint.transform.origin
	$Patches2/Armature/Skeleton/SkeletonIK.start()
	if removeGroupOnReady:
		remove_from_group("Patches")
	print("patches: ready - ", get_parent().name)
	pass

func _process(delta):
	if isLookingAtPlayer:
		var nt = global_transform.looking_at(Vector3(Global.Player.global_transform.origin.x,global_transform.origin.y,Global.Player.global_transform.origin.z), Vector3.UP)
		var nt_q = nt.basis.get_rotation_quat()
		var rotAngle = rad2deg(nt_q.get_euler().y) + 180
		if abs(rotAngle - rad2deg(global_transform.basis.get_euler().y)) > 15:
			nt_q.set_axis_angle(Vector3.UP, deg2rad(rotAngle))
			nt.basis = Basis(nt_q)
			global_transform = global_transform.interpolate_with(nt, 0.02)
		if global_transform.origin.distance_to(Global.Player.global_transform.origin) > (lookDistance):
			point_head(delta)
#		else:
#			point_head(delta, $HeadPointOrigin.global_transform.origin)


func exit_dialogue():
	$Interactable.set_interactable(false)
	$RenableInteractible.start(1.0)

func get_dialogue_point():
	return "Patches/" + (("0" + String(dialoguePoint)) if dialoguePoint < 10 else String(dialoguePoint))

func get_speaking_volume():
	return speakingVolume
	pass

func get_talk_sfx():
	#return "res://Sounds/guide_0" + String(Global.world.rng.randi_range(1,4)) + ".wav"
	return Utils.get_random(sfx)

func increment_timeline():
	dialoguePoint += 1
	pass

func point_head(delta, targetPoint = Global.Player.get_head().global_transform.origin + Vector3(0,2,0)):
	var hp = $Patches2/Armature/Skeleton/HeadPoint
	var GT = hp.global_transform
	var looking = GT.looking_at(targetPoint, Vector3.DOWN)
	var newpoint = $HeadPointStart.global_transform.origin + ($HeadPointStart.global_transform.origin.direction_to(targetPoint) * (min(lookDistance, $HeadPointStart.global_transform.origin.distance_to(targetPoint))))
	GT = GT.interpolate_with(looking, 0.01)
	hp.global_transform = GT
	hp.global_transform.origin = hp.global_transform.origin.linear_interpolate(newpoint, 0.01)
	
	
	#print("head ", $Patches2/Armature/Skeleton/HeadPoint.global_transform.origin)
	#$Patches2/Armature/Skeleton/HeadPoint.global_transform = $Patches2/Armature/Skeleton/HeadPoint.global_transform.looking_at(targetPoint, Vector3.DOWN)
	#$Patches2/Armature/Skeleton/HeadPoint.rotation_degrees.x += 50
	#var newPoint = headPointOrigin + $Patches2/Armature/Skeleton/HeadPoint.global_transform.origin.direction_to(targetPoint).normalized() * 2
	#var newPoint = $HeadPointOrigin.global_transform.origin + $Patches2/Armature/Skeleton/HeadPoint.global_transform.origin.direction_to(targetPoint).normalized() * 2
	#$Patches2/Armature/Skeleton/HeadPoint.global_transform.origin = $Patches2/Armature/Skeleton/HeadPoint.global_transform.origin.linear_interpolate(newPoint, delta)
	pass

func ready_dialogue(controller):
	#var ds = dsRef.instance()
	var ds = load("res://prefabs/UI/Dialogue/Dialogic_NPC_DialogueScreen.tscn").instance()
	Global.world.add_child(ds)
	ds.initialize({'speaker':self, 'listener':controller.get_parent(), 'text':["hellow", "world"], "timelineName":get_dialogue_point()})
	controller.begin_dialogue(self)

func save():
	return Utils.serialize_node(self)

func set_can_interact(val = true):
	$Interactable.set_interactable(val)

func _on_Area_body_entered(body):
	if body == Global.Player:
		print("Player Entered")
		isLookingAtPlayer = true
	pass # Replace with function body.


func _on_Interactable_emit_prompt(_prompt):
	_prompt.prompt = "Talk"
	pass # Replace with function body.


func _on_Interactable_interaction(controller):
	ready_dialogue(controller)
	pass # Replace with function body.


func _on_RenableInteractible_timeout():
	$Interactable.set_interactable(true)
	pass # Replace with function body.
