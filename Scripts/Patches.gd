extends Spatial

var isLookingAtPlayer = false
var headPointOrigin = Vector3()

var ds = null

export(Array, Resource) var options = []

func _ready():
	headPointOrigin = $Patches2/Armature/Skeleton/HeadPoint.global_transform.origin
	$Patches2/Armature/Skeleton/SkeletonIK.start()
	pass

func _process(delta):
	if isLookingAtPlayer:
		var nt = global_transform.looking_at(Vector3(Global.Player.global_transform.origin.x,global_transform.origin.y,Global.Player.global_transform.origin.z), Vector3.UP)
		var nt_q = nt.basis.get_rotation_quat()
		var rotAngle = rad2deg(nt_q.get_euler().y) + 180
		#print(rotAngle, " - " , rad2deg(global_transform.basis.get_euler().y))
#		print(abs(rotAngle - rad2deg(global_transform.basis.get_euler().y)))
		if abs(rotAngle - rad2deg(global_transform.basis.get_euler().y)) > 15:
			nt_q.set_axis_angle(Vector3.UP, deg2rad(rotAngle))
##		#if abs(deg2rad(nt_q.get_euler().y) - deg2rad(nt.basis.get_euler().y)) > 45:
			nt.basis = Basis(nt_q)
#			global_transform = nt
			global_transform = global_transform.interpolate_with(nt, 0.02)
		#rotate_y(deg2rad(180))
		if global_transform.origin.distance_to(Global.Player.global_transform.origin) > 2.4:
			point_head(delta)
			
func check_options():
	var check = false
	for i in options:
		if i.name == "Exit":
			if check:
				return false
			else:
				check = true

func get_options():
	#remove_exits_by_name("Exit")
	return options

func set_options(nextOptions):
	options = nextOptions
	#remove_exits_by_name("Exit")
	options.append(load("res://prefabs/UI/Dialogue/Exit.tscn"))

func point_head(delta):
	$Patches2/Armature/Skeleton/HeadPoint.global_transform = $Patches2/Armature/Skeleton/HeadPoint.global_transform.looking_at(Global.Player.get_head().global_transform.origin, Vector3.DOWN)
	$Patches2/Armature/Skeleton/HeadPoint.rotation_degrees.x += 50
	var newPoint = headPointOrigin + $Patches2/Armature/Skeleton/HeadPoint.global_transform.origin.direction_to(Global.Player.get_head().global_transform.origin).normalized() * 2
	$Patches2/Armature/Skeleton/HeadPoint.global_transform.origin = $Patches2/Armature/Skeleton/HeadPoint.global_transform.origin.linear_interpolate(newPoint, delta)

func remove_exits_by_name(nam):
	for i in options:
		if i.resource_name == nam:
			options.erase(i)
	pass

func _on_Area_body_entered(body):
	if body == Global.Player:
		print("Player Entered")
		isLookingAtPlayer = true
	pass # Replace with function body.


func _on_Interactable_emit_prompt(_prompt):
	_prompt.prompt = "Talk"
	pass # Replace with function body.


func _on_Interactable_interaction(controller):
	ds = load("res://prefabs/UI/Dialogue/PatchesDialogueScreen.tscn").instance()
	add_child(ds)
	ds.initialize({'speaker':self, 'listener':controller.get_parent(), 'text':["hellow", "world"], 'init_options':options})
	controller.begin_dialogue(self)
	pass # Replace with function body.
