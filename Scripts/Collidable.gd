extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area_area_shape_entered(area_id, area, area_shape, self_shape):
	print(area)


func _on_Area_body_entered(body):
	if body.has_method("collision_effect"):
		body.collision_effect(owner)
	pass
