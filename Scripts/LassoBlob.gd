extends KinematicBody

onready var material = $MeshInstance.get_surface_material(0)
var a = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#func _process(delta):
	#a -= 0.02
	#material.albedo_color -= Color(0.02,0.02,0.02,0.02)
	
	#if(a <= 0.0):
	#	queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
