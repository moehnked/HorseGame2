tool
extends StaticBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$marblewall.set_surface_material(0, $marblewall.get_surface_material(0).duplicate(7))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.editor_hint:
		$marblewall.get_surface_material(0).set_shader_param("front_random_scale", global_transform.origin.length())
#	pass
