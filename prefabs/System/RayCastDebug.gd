extends RayCast


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	print("raycast owner - ", owner.name)
	LineCode.initialize(owner.get_camera())
	pass # Replace with function body.

func _process(delta):
	if is_colliding():
		print(get_collider().name)
		#LineCode.Draw_Line3D(0, global_transform.origin, get_collision_point(), Color(1,1,1), 3.0)
		LineCode.DrawLine(global_transform.origin, get_collision_point(), Color(0, 0, 1), 0.01)
	pass
