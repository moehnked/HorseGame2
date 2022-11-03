tool

extends Spatial

export(int,0,7) var xo = 1
export(int,0,7) var yo = 0
export(int,0,4) var isBillboard = 0
export(bool) var isWiggleEnabled = true

var startingZ
var wiggledir
export(bool) var isChosenOne = false


func _ready():
	#$MeshInstance.set_surface_material(0, $MeshInstance.get_surface_material(0).duplicate(7))
	$MeshInstance.get_surface_material(0).uv1_offset.x = 0.125 * xo
	$MeshInstance.get_surface_material(0).uv1_offset.y = 0.125 * yo
	$MeshInstance.get_surface_material(0).params_billboard_mode = isBillboard
	wiggledir = -.1 if randi() % 2 == 0 else .1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.editor_hint:
		$MeshInstance.get_surface_material(0).params_depth_draw_mode = SpatialMaterial.DEPTH_DRAW_ALPHA_OPAQUE_PREPASS
		$MeshInstance.get_surface_material(0).flags_do_not_receive_shadows = true
		$MeshInstance.get_surface_material(0).uv1_offset.x = 0.125 * xo
		$MeshInstance.get_surface_material(0).uv1_offset.y = 0.125 * yo
		$MeshInstance.get_surface_material(0).params_billboard_mode = isBillboard
		pass
	pass

func wiggle(rot):
	if isWiggleEnabled:
		#startingZ += wiggledir * delta
		#rotation_degrees.x = sin(startingZ) * 10
		#rotation_degrees.z = rotation_degrees.x
		#startingZ = Global.world.get_wiggle_rot() * wiggledir
		startingZ = rot * wiggledir
		rotation_degrees.x += startingZ
		rotation_degrees.z += startingZ
