extends Spatial

var isLookingAtPlayer = false
var headPointOrigin = Vector3()

func _ready():
	headPointOrigin = $Patches2/Armature/Skeleton/HeadPoint.global_transform.origin
	$Patches2/Armature/Skeleton/SkeletonIK.start()
	pass

func _process(delta):
	if isLookingAtPlayer:
		$Patches2/Armature/Skeleton/HeadPoint.global_transform = $Patches2/Armature/Skeleton/HeadPoint.global_transform.looking_at(Global.Player.get_head().global_transform.origin, Vector3.DOWN)
		$Patches2/Armature/Skeleton/HeadPoint.rotation_degrees.x += 50
		var newPoint = headPointOrigin + $Patches2/Armature/Skeleton/HeadPoint.global_transform.origin.direction_to(Global.Player.get_head().global_transform.origin).normalized() * 2
		$Patches2/Armature/Skeleton/HeadPoint.global_transform.origin = $Patches2/Armature/Skeleton/HeadPoint.global_transform.origin.linear_interpolate(newPoint, delta)

func _on_Area_body_entered(body):
	if body == Global.Player:
		print("Player Entered")
		isLookingAtPlayer = true
	pass # Replace with function body.
